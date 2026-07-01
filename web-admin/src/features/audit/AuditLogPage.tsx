import { Alert, Descriptions, Drawer } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";

type AuditLog = {
  id: string;
  actorId: string;
  actorName?: string;
  action: string;
  entityType: string;
  entityId: string;
  details: string;
  ipAddress: string;
  createdAt: string;
};

export default function AuditLogPage() {
  const { t } = useTranslation();
  const [items, setItems] = useState<AuditLog[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selected, setSelected] = useState<AuditLog | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await apiClient.get<PageResponse<AuditLog>>(API.AUDIT_LOGS, { params: { page: 0, size: 100 } });
      setItems(res.data.items ?? []);
    } catch {
      setError(t("pages.audit.loadError"));
    } finally { setLoading(false); }
  }, [t]);

  useEffect(() => { void load(); }, [load]);

  const columns = useMemo<ColumnsType<AuditLog>>(() => [
    { title: t("pages.audit.time"), dataIndex: "createdAt", width: 180 },
    {
      title: t("pages.audit.action"), dataIndex: "action", width: 160,
      render: (v: string) => <strong>{v}</strong>
    },
    { title: t("pages.audit.entity"), dataIndex: "entityType", width: 140 },
    { title: t("pages.audit.entityId"), dataIndex: "entityId", width: 120, render: (v: string) => v || "-" },
    { title: t("pages.audit.actor"), dataIndex: "actorName", width: 180, render: (v: string) => v || "-" },
    { title: "IP", dataIndex: "ipAddress", width: 130 }
  ], [t]);

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.audit.title")}</h1>
        <p>{t("pages.audit.subtitle")}</p>
      </div>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<AuditLog> rowKey="id" loading={loading} columns={columns} dataSource={items}
        pagination={false}
        onRow={(row) => ({ onClick: () => setSelected(row), style: { cursor: "pointer" } })} />

      <Drawer title={t("pages.audit.drawerTitle")} width="min(480px, calc(100vw - 32px))" open={!!selected}
        onClose={() => setSelected(null)}>
        {selected && (
          <Descriptions bordered column={1} size="middle">
            <Descriptions.Item label="ID">-</Descriptions.Item>
            <Descriptions.Item label={t("pages.audit.action")}>{selected.action}</Descriptions.Item>
            <Descriptions.Item label={t("pages.audit.entity")}>{selected.entityType ?? "-"}</Descriptions.Item>
            <Descriptions.Item label={t("pages.audit.entityId")}>-</Descriptions.Item>
            <Descriptions.Item label={t("pages.audit.actor")}>{selected.actorName ?? selected.actorId ?? "-"}</Descriptions.Item>
            <Descriptions.Item label={t("pages.audit.ipAddress")}>{selected.ipAddress ?? "-"}</Descriptions.Item>
            <Descriptions.Item label={t("pages.audit.time")}>{selected.createdAt}</Descriptions.Item>
            <Descriptions.Item label={t("common.detail")}>{selected.details ?? "-"}</Descriptions.Item>
          </Descriptions>
        )}
      </Drawer>
    </>
  );
}
