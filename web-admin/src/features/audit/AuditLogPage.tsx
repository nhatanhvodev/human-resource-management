import { Alert, Descriptions, Drawer } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";

type AuditLog = {
  id: string;
  actorId: string;
  action: string;
  entityType: string;
  entityId: string;
  details: string;
  ipAddress: string;
  createdAt: string;
};

export default function AuditLogPage() {
  const [items, setItems] = useState<AuditLog[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selected, setSelected] = useState<AuditLog | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await apiClient.get<PageResponse<AuditLog>>("/audit-logs", { params: { page: 0, size: 100 } });
      setItems(res.data.items ?? []);
    } catch {
      setError("Không tải được nhật ký hệ thống.");
    } finally { setLoading(false); }
  }, []);

  useEffect(() => { void load(); }, [load]);

  const columns = useMemo<ColumnsType<AuditLog>>(() => [
    { title: "Thời gian", dataIndex: "createdAt", width: 180 },
    {
      title: "Hành động", dataIndex: "action", width: 160,
      render: (v: string) => <strong>{v}</strong>
    },
    { title: "Đối tượng", dataIndex: "entityType", width: 140 },
    { title: "ID đối tượng", dataIndex: "entityId", width: 120, render: (v: string) => v ? v.slice(0, 8) : "-" },
    { title: "Người thực hiện", dataIndex: "actorId", width: 120, render: (v: string) => v ? v.slice(0, 8) : "-" },
    { title: "IP", dataIndex: "ipAddress", width: 130 }
  ], []);

  return (
    <>
      <div className="page-header">
        <h1>Nhật ký hệ thống</h1>
        <p>Theo dõi các hành động trong hệ thống để kiểm toán và bảo mật.</p>
      </div>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<AuditLog> rowKey="id" loading={loading} columns={columns} dataSource={items}
        pagination={false}
        onRow={(row) => ({ onClick: () => setSelected(row), style: { cursor: "pointer" } })} />

      <Drawer title="Chi tiết nhật ký" width="min(480px, calc(100vw - 32px))" open={!!selected}
        onClose={() => setSelected(null)}>
        {selected && (
          <Descriptions bordered column={1} size="middle">
            <Descriptions.Item label="ID">{selected.id}</Descriptions.Item>
            <Descriptions.Item label="Hành động">{selected.action}</Descriptions.Item>
            <Descriptions.Item label="Loại đối tượng">{selected.entityType ?? "-"}</Descriptions.Item>
            <Descriptions.Item label="ID đối tượng">{selected.entityId ?? "-"}</Descriptions.Item>
            <Descriptions.Item label="Người thực hiện">{selected.actorId ?? "-"}</Descriptions.Item>
            <Descriptions.Item label="Địa chỉ IP">{selected.ipAddress ?? "-"}</Descriptions.Item>
            <Descriptions.Item label="Thời gian">{selected.createdAt}</Descriptions.Item>
            <Descriptions.Item label="Chi tiết">{selected.details ?? "-"}</Descriptions.Item>
          </Descriptions>
        )}
      </Drawer>
    </>
  );
}
