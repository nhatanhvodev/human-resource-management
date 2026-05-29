import { Alert, Card, Col, Row, Skeleton, Statistic, Table } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useEffect, useState } from "react";

import { apiClient } from "../../shared/api/client";

type DashboardSummary = {
  employees: number;
  departments: number;
  openPayrollPeriods: number;
  pendingLeaves: number;
};

type DashboardActivity = {
  type: string;
  message: string;
  timestamp: string;
};

const defaultSummary: DashboardSummary = {
  employees: 0,
  departments: 0,
  openPayrollPeriods: 0,
  pendingLeaves: 0
};

const activityColumns: ColumnsType<DashboardActivity> = [
  { title: "Type", dataIndex: "type", width: 180 },
  { title: "Message", dataIndex: "message" },
  { title: "Time", dataIndex: "timestamp", width: 220 }
];

export default function DashboardPage() {
  const [summary, setSummary] = useState<DashboardSummary>(defaultSummary);
  const [activities, setActivities] = useState<DashboardActivity[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;

    async function loadDashboard() {
      setLoading(true);
      setError(null);
      try {
        const [summaryResponse, activityResponse] = await Promise.all([
          apiClient.get<DashboardSummary>("/dashboard/summary"),
          apiClient.get<DashboardActivity[]>("/dashboard/activities")
        ]);

        if (mounted) {
          setSummary({
            ...defaultSummary,
            ...(typeof summaryResponse.data === "object" && summaryResponse.data !== null ? summaryResponse.data : {})
          });
          setActivities(Array.isArray(activityResponse.data) ? activityResponse.data : []);
        }
      } catch {
        if (mounted) {
          setError("Unable to load dashboard data. Check token, tenant, and backend connectivity.");
        }
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    }

    void loadDashboard();

    return () => {
      mounted = false;
    };
  }, []);

  return (
    <>
      <div className="page-header">
        <h1>Dashboard</h1>
        <p>Operational summary for HR administration.</p>
      </div>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <Row gutter={[16, 16]} className="summary-grid">
        <Col xs={24} sm={12} lg={6}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Employees" value={summary.employees} />
            </Skeleton>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Departments" value={summary.departments} />
            </Skeleton>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Open Payroll" value={summary.openPayrollPeriods} />
            </Skeleton>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Pending Leaves" value={summary.pendingLeaves} />
            </Skeleton>
          </Card>
        </Col>
      </Row>

      <Table
        rowKey={(row) => `${row.type}-${row.timestamp}`}
        loading={loading}
        dataSource={activities}
        columns={activityColumns}
        pagination={false}
      />
    </>
  );
}
