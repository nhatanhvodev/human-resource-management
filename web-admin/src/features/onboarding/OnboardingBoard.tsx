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
import { useEffect, useState } from "react";
import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";

type TaskItem = { id: string; employeeId: string; title: string; description: string; status: string; completedAt: string | null };
type Employee = { id: string; employeeNo: string; fullName: string };

const COLUMNS = [
  { key: "TODO", label: "Cần làm", color: "#faad14" },
  { key: "IN_PROGRESS", label: "Đang làm", color: "#1677ff" },
  { key: "DONE", label: "Hoàn tất", color: "#52c41a" }
];

function Column({ column, children }: { column: typeof COLUMNS[0]; children: React.ReactNode }) {
  const { setNodeRef } = useDroppable({ id: column.key });
  return (
    <div ref={setNodeRef} style={{ background: "#f5f5f5", borderRadius: 8, padding: 8, minHeight: 200, flex: 1, minWidth: 200 }}>
      <div style={{ fontWeight: 600, textAlign: "center", padding: "0 4px 8px", borderBottom: `3px solid ${column.color}` }}>
        {column.label}
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
  const [tasks, setTasks] = useState<TaskItem[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [selectedEmployee, setSelectedEmployee] = useState<string | null>(null);
  const [activeId, setActiveId] = useState<string | null>(null);
  const activeTask = tasks.find(t => t.id === activeId);
  const sensors = useSensors(useSensor(PointerSensor, { activationConstraint: { distance: 5 } }));

  useEffect(() => {
    apiClient.get<PageResponse<Employee>>("/employees", { params: { page: 0, size: 100, status: "ACTIVE" } })
      .then(r => setEmployees(r.data.items ?? [])).catch(() => {});
  }, []);

  useEffect(() => {
    if (selectedEmployee) {
      apiClient.get<TaskItem[]>(`/onboarding/tasks/${selectedEmployee}`)
        .then(r => setTasks(r.data ?? [])).catch(() => setTasks([]));
    } else {
      setTasks([]);
    }
  }, [selectedEmployee]);

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
        await apiClient.post(`/onboarding/tasks/${taskId}/complete`);
        setTasks(prev => prev.map(t => t.id === taskId ? { ...t, status: "DONE", completedAt: new Date().toISOString() } : t));
        message.success("Đã hoàn tất task");
      } catch { message.error("Không thể hoàn tất"); }
    }
  };

  const handleStart = () => {
    if (tasks.length > 0) return;
    // tasks count is 0, means either no employee selected or no tasks exist
    // just reload to check
    if (selectedEmployee) {
      apiClient.get<TaskItem[]>(`/onboarding/tasks/${selectedEmployee}`)
        .then(r => { setTasks(r.data ?? []); if (r.data?.length === 0) message.info("Không có task onboarding cho nhân viên này"); })
        .catch(() => {});
    }
  };

  const itemsByStatus = (status: string) => tasks.filter(t => t.status === status);

  return (
    <div>
      <div style={{ marginBottom: 16, display: "flex", gap: 12, alignItems: "center" }}>
        <Select
          style={{ width: 320 }}
          showSearch
          placeholder="Chọn nhân viên để xem onboarding"
          allowClear
          value={selectedEmployee}
          onChange={setSelectedEmployee}
          options={employees.map(e => ({ value: e.id, label: `${e.employeeNo} - ${e.fullName}` }))}
        />
        <Button onClick={handleStart}>Tải lại</Button>
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
