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
import { useDroppable } from "@dnd-kit/core";
import { useDraggable } from "@dnd-kit/core";
import { Card, message } from "antd";
import { useCallback, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
import type { PageResponse } from "../../shared/api/types";
import { StatusTag } from "../../shared/ui/StatusTag";

type Application = {
  id: string;
  applicationNo?: string;
  candidateName?: string;
  jobTitle?: string;
  status: string;
};

const STAGES = ["SCREEN", "PHONE_INTERVIEW", "TECHNICAL", "ONSITE", "OFFER", "HIRED", "REJECTED"];

const STAGE_COLORS: Record<string, string> = {
  SCREEN: "#faad14",
  PHONE_INTERVIEW: "#1677ff",
  TECHNICAL: "#722ed1",
  ONSITE: "#13c2c2",
  OFFER: "#52c41a",
  HIRED: "#389e0d",
  REJECTED: "#ff4d4f"
};

function DroppableColumn({ stage, children }: { stage: string; children: React.ReactNode }) {
  const { t } = useTranslation();
  const { setNodeRef } = useDroppable({ id: stage });
  return (
    <div ref={setNodeRef} style={{
      background: "#f5f5f5", borderRadius: 8, padding: 8, minHeight: 200,
      minWidth: 200, flex: "0 0 auto", width: 240
    }}>
      <div style={{
        fontWeight: 600, padding: "0 4px 8px", textAlign: "center",
        borderBottom: `3px solid ${STAGE_COLORS[stage] ?? "#ddd"}`
      }}>
        {t(`pages.recruitment.stage.${stage}`, stage)}
      </div>
      {children}
    </div>
  );
}

function KanbanCard({ app }: { app: Application }) {
  const { attributes, listeners, setNodeRef, transform, isDragging } = useDraggable({ id: app.id });
  const style = transform ? {
    transform: `translate3d(${transform.x}px, ${transform.y}px, 0)`,
    opacity: isDragging ? 0.5 : 1
  } : {};

  return (
    <div ref={setNodeRef} {...listeners} {...attributes} style={{ ...style, marginBottom: 8, cursor: "grab" }}>
      <Card size="small" hoverable>
        <div style={{ fontWeight: 500, fontSize: 13 }}>{app.candidateName ?? app.applicationNo ?? "-"}</div>
        <div style={{ fontSize: 12, color: "#888" }}>{app.jobTitle ?? "-"}</div>
        <div style={{ marginTop: 4 }}><StatusTag value={app.status} /></div>
      </Card>
    </div>
  );
}

export default function RecruitmentKanban({ applications }: { applications: Application[] }) {
  const { t } = useTranslation();
  const [items, setItems] = useState<Application[]>(applications);
  const [activeId, setActiveId] = useState<string | null>(null);
  const activeApp = items.find(a => a.id === activeId);

  useEffect(() => { setItems(applications); }, [applications]);

  const sensors = useSensors(useSensor(PointerSensor, { activationConstraint: { distance: 5 } }));

  const handleDragStart = (event: DragStartEvent) => {
    setActiveId(String(event.active.id));
  };

  const handleDragEnd = async (event: DragEndEvent) => {
    setActiveId(null);
    const { active, over } = event;
    if (!over) return;

    const appId = String(active.id);
    const newStage = String(over.id);

    const app = items.find(a => a.id === appId);
    if (!app || app.status === newStage) return;

    try {
      await apiClient.post(`/applications/${appId}/move-stage?stage=${newStage}`);
      setItems(prev => prev.map(a => a.id === appId ? { ...a, status: newStage } : a));
      message.success(t("pages.recruitment.moveSuccess", { stage: t(`pages.recruitment.stage.${newStage}`, newStage) }));
    } catch {
      message.error(t("pages.recruitment.moveError"));
    }
  };

  const appsByStage = (stage: string) => items.filter(a => a.status === stage);

  return (
    <DndContext sensors={sensors} collisionDetection={closestCorners} onDragStart={handleDragStart} onDragEnd={handleDragEnd}>
      <div style={{ display: "flex", gap: 12, overflow: "auto", paddingBottom: 16 }}>
        {STAGES.map(stage => (
          <DroppableColumn key={stage} stage={stage}>
            {appsByStage(stage).map(app => (
              <KanbanCard key={app.id} app={app} />
            ))}
          </DroppableColumn>
        ))}
      </div>
      <DragOverlay>
        {activeApp ? <KanbanCard app={activeApp} /> : null}
      </DragOverlay>
    </DndContext>
  );
}
