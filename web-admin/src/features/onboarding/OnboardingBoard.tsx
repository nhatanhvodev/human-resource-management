import {
  closestCorners,
  DndContext,
  DragEndEvent,
  DragOverlay,
  DragStartEvent,
  PointerSensor,
  useSensor,
  useSensors
} from "@dnd-kit/core";
import { useDroppable, useDraggable } from "@dnd-kit/core";
import { Button, Card, Form, Input, Select, message } from "antd";
import { useState } from "react";
import { useTranslation } from "react-i18next";
import type { UseQueryResult } from "@tanstack/react-query";
import { API } from "../../shared/api/endpoints";
// NOTE: `as UseQueryResult<...>` restores useApiQuery's documented return type, which currently
// degrades under the installed @tanstack/react-query 5.102.8 (overload error inside query.ts).
// The cast is type-only and has zero runtime effect.
import { useApiMutation, useApiQuery } from "../../shared/api/query";
import type { PageResponse } from "../../shared/api/types";

type TaskItem = { id: string; employeeId: string; title: string; description: string; status: string; completedAt: string | null };
type Employee = { id: string; employeeNo: string; fullName: string };

const COLUMNS = [
  { key: "TODO", color: "#faad14" },
  { key: "IN_PROGRESS", color: "#1677ff" },
  { key: "DONE", color: "#52c41a" }
];

function Column({ column, children }: { column: typeof COLUMNS[0]; children: React.ReactNode }) {
  const { t } = useTranslation();
  const { setNodeRef } = useDroppable({ id: column.key });
  return (
    <div ref={setNodeRef} style={{ background: "#f5f5f5", borderRadius: 8, padding: 8, minHeight: 200, flex: 1, minWidth: 200 }}>
      <div style={{ fontWeight: 600, textAlign: "center", padding: "0 4px 8px", borderBottom: `3px solid ${column.color}` }}>
        {t(`status.${column.key}`, column.key)}
      </div>
      {children}
    </div>
  );
}

function TaskCard({ task }: { task: TaskItem }) {
  const { attributes, listeners, setNodeRef, transform, isDragging } = useDraggable({ id: task.id });
  const style = transform ? { transform: `translate3d(${transform.x}px, ${transform.y}px, 0)`, opacity: isDragging ? 0.5 : 1 } : {};
  return (
    <div ref={setNodeRef} {...listeners} {...attributes} style={{ ...style, marginBottom: 8, cursor: "grab" }}>
      <Card size="small" hoverable>
        <div style={{ fontWeight: 500 }}>{task.title}</div>
        <div style={{ fontSize: 12, color: "#888" }}>{task.description ?? ""}</div>
      </Card>
    </div>
  );
}

export default function OnboardingBoard() {
  const { t } = useTranslation();
  const [selectedEmployee, setSelectedEmployee] = useState<string | null>(null);
  const [activeId, setActiveId] = useState<string | null>(null);
  const sensors = useSensors(useSensor(PointerSensor, { activationConstraint: { distance: 5 } }));

  const employeesQuery = useApiQuery<PageResponse<Employee>>(["onboarding", "board-employees"], API.EMPLOYEES, {
    config: { params: { page: 0, size: 100, status: "ACTIVE" } }
  }) as UseQueryResult<PageResponse<Employee>, unknown>;
  // Same URL shape as before (/onboarding/tasks/:employeeId); disabled until an employee is picked.
  const tasksQuery = useApiQuery<TaskItem[]>(
    ["onboarding", "board-tasks", selectedEmployee],
    selectedEmployee ? `${API.ONBOARDING.TASKS}/${selectedEmployee}` : API.ONBOARDING.TASKS,
    { enabled: !!selectedEmployee }
  ) as UseQueryResult<TaskItem[], unknown>;
  const completeMutation = useApiMutation({
    invalidateKeys: [["onboarding", "board-tasks"]]
  });

  const employees = employeesQuery.data?.items ?? [];
  const tasks = tasksQuery.data ?? [];
  const activeTask = tasks.find(t => t.id === activeId);

  const handleDragEnd = async (event: DragEndEvent) => {
    setActiveId(null);
    const { active, over } = event;
    if (!over) return;
    const taskId = String(active.id);
    const targetStatus = String(over.id);

    const task = tasks.find(t => t.id === taskId);
    if (!task || task.status === targetStatus) return;

    if (targetStatus === "DONE") {
      try {
        await completeMutation.mutateAsync({ url: `${API.ONBOARDING.TASKS}/${taskId}/complete`, body: null });
        message.success(t("pages.onboarding.taskCompleted"));
      } catch { message.error(t("pages.onboarding.taskCompleteError")); }
    }
  };

  const handleStart = () => {
    if (tasks.length > 0) return;
    // tasks count is 0, means either no employee selected or no tasks exist
    // just reload to check
    if (selectedEmployee) {
      void tasksQuery.refetch().then((result) => {
        if ((result.data ?? []).length === 0) message.info(t("pages.onboarding.noTasksForEmployee"));
      });
    }
  };

  const itemsByStatus = (status: string) => tasks.filter(t => t.status === status);

  return (
    <div>
      <div style={{ marginBottom: 16, display: "flex", gap: 12, alignItems: "center" }}>
        <Select
          style={{ width: 320 }}
          showSearch
          placeholder={t("pages.onboarding.boardEmployeePlaceholder")}
          allowClear
          value={selectedEmployee}
          onChange={setSelectedEmployee}
          options={employees.map(e => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))}
        />
        <Button onClick={handleStart}>{t("pages.onboarding.reload")}</Button>
      </div>

      <DndContext sensors={sensors} collisionDetection={closestCorners} onDragStart={(e) => setActiveId(String(e.active.id))} onDragEnd={handleDragEnd}>
        <div style={{ display: "flex", gap: 12 }}>
          {COLUMNS.map(c => (
            <Column key={c.key} column={c}>
              {itemsByStatus(c.key).map(t => <TaskCard key={t.id} task={t} />)}
            </Column>
          ))}
        </div>
        <DragOverlay>
          {activeTask ? <TaskCard task={activeTask} /> : null}
        </DragOverlay>
      </DndContext>
    </div>
  );
}
