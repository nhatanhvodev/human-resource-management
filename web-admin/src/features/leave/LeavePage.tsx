import { Alert, Button, Space } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useEffect, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type LeaveRequest = {
  id: string;
  employeeName?: string;
  leaveType?: string;
  startDate?: string;
  endDate?: string;
  status: string;
};

const columns: ColumnsType<LeaveRequest> = [
  { title: "Employee", dataIndex: "employeeName" },
  { title: "Type", dataIndex: "leaveType", width: 160 },
  { title: "Start", dataIndex: "startDate", width: 150 },
  { title: "End", dataIndex: "endDate", width: 150 },
  {
    title: "Status",
    dataIndex: "status",
    width: 160,
    render: (value: string) => <StatusTag value={value} />
  },
  {
    title: "Actions",
    key: "actions",
    width: 190,
    render: () => (
      <Space>
        <Button size="small">Approve</Button>
        <Button size="small" danger>
          Reject
        </Button>
      </Space>
    )
  }
];

export default function LeavePage() {
  const [items, setItems] = useState<LeaveRequest[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;

    async function loadLeaveRequests() {
      setLoading(true);
      setError(null);
      try {
        const response = await apiClient.get<PageResponse<LeaveRequest>>("/leave-requests", {
          params: { page: 0, size: 10 }
        });
        if (mounted) {
          setItems(response.data.items ?? []);
        }
      } catch {
        if (mounted) {
          setError("Unable to load leave requests. Check token, tenant, and backend connectivity.");
        }
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    }

    void loadLeaveRequests();

    return () => {
      mounted = false;
    };
  }, []);

  return (
    <>
      <div className="page-header">
        <h1>Leave</h1>
        <p>Review leave requests and manage approval decisions.</p>
      </div>

      <PageToolbar>
        <Space />
        <Button type="primary">Create leave request</Button>
      </PageToolbar>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <AppTable<LeaveRequest>
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={items}
        pagination={false}
      />
    </>
  );
}
