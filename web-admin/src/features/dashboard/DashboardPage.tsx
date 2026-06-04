import { Alert, Card, Col, Row, Skeleton, Statistic, Table } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useEffect, useState } from "react";

import { apiClient } from "../../shared/api/client";

type DashboardSummary = {
  totalEmployees: number;
  activeEmployees: number;
  departments: number;
  openPayrollPeriods: number;
  pendingLeaves: number;
};

type DepartmentHeadcount = {
  departmentId: string;
  departmentName: string;
  count: number;
};

type DashboardActivity = {
  type: string;
  message: string;
  timestamp: string;
};

const defaultSummary: DashboardSummary = {
  totalEmployees: 0,
  activeEmployees: 0,
  departments: 0,
  openPayrollPeriods: 0,
  pendingLeaves: 0
};

const activityColumns: ColumnsType<DashboardActivity> = [
  { title: "Loại", dataIndex: "type", width: 180 },
  { title: "Nội dung", dataIndex: "message" },
  { title: "Thời gian", dataIndex: "timestamp", width: 220 }
];

export default function DashboardPage() {
  const [summary, setSummary] = useState<DashboardSummary>(defaultSummary);
  const [activities, setActivities] = useState<DashboardActivity[]>([]);
  const [headcounts, setHeadcounts] = useState<DepartmentHeadcount[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;

    async function loadDashboard() {
      setLoading(true);
      setError(null);
      try {
        const [summaryResponse, activityResponse, headcountResponse] = await Promise.all([
          apiClient.get<DashboardSummary>("/dashboard/summary"),
          apiClient.get<DashboardActivity[]>("/dashboard/activities"),
          apiClient.get<DepartmentHeadcount[]>("/dashboard/headcount-by-department")
        ]);

        if (mounted) {
          setSummary({
            ...defaultSummary,
            ...(typeof summaryResponse.data === "object" && summaryResponse.data !== null ? summaryResponse.data : {})
          });
          setActivities(Array.isArray(activityResponse.data) ? activityResponse.data : []);
          setHeadcounts(Array.isArray(headcountResponse.data) ? headcountResponse.data : []);
        }
      } catch {
        if (mounted) {
          setError("Không tải được dữ liệu tổng quan. Kiểm tra token, tenant và kết nối backend.");
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
        <h1>Tổng quan</h1>
        <p>Tóm tắt vận hành cho hệ thống quản trị nhân sự.</p>
      </div>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <Row gutter={[16, 16]} className="summary-grid">
        <Col xs={24} sm={12} lg={4}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Tổng nhân viên" value={summary.totalEmployees} />
            </Skeleton>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={4}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Đang làm việc" value={summary.activeEmployees} valueStyle={{ color: '#3f8600' }} />
            </Skeleton>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={4}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Phòng ban" value={summary.departments} />
            </Skeleton>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={4}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Kỳ lương đang mở" value={summary.openPayrollPeriods} />
            </Skeleton>
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={6}>
          <Card className="summary-card">
            <Skeleton loading={loading} active paragraph={false}>
              <Statistic title="Đơn nghỉ chờ duyệt" value={summary.pendingLeaves} valueStyle={{ color: summary.pendingLeaves > 0 ? '#cf1322' : undefined }} />
            </Skeleton>
          </Card>
        </Col>
      </Row>

      {headcounts.length > 0 && (
        <Card title="Nhân viên theo phòng ban" style={{ marginBottom: 16 }}>
          <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
            {headcounts.map((h) => {
              const maxCount = Math.max(...headcounts.map(x => x.count), 1);
              const pct = Math.round((h.count / maxCount) * 100);
              return (
                <div key={h.departmentId} style={{ display: "flex", alignItems: "center", gap: 8 }}>
                  <div style={{ width: 180, textAlign: "right", fontSize: 13, flexShrink: 0 }}>{h.departmentName}</div>
                  <div style={{ flex: 1, background: "#f0f0f0", borderRadius: 4, height: 22, overflow: "hidden" }}>
                    <div style={{
                      width: `${pct}%`,
                      height: "100%",
                      background: "linear-gradient(90deg, #1677ff, #69b1ff)",
                      borderRadius: 4,
                      transition: "width 0.5s ease",
                      minWidth: h.count > 0 ? 24 : 0,
                      display: "flex",
                      alignItems: "center",
                      paddingLeft: 8
                    }}>
                      <span style={{ color: "#fff", fontSize: 12, fontWeight: 500 }}>{h.count}</span>
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </Card>
      )}

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
