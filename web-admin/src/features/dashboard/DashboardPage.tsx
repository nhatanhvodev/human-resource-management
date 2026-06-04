import { Alert, Card, Col, Empty, Row, Skeleton, Statistic, Table, Typography } from "antd";
import type { ColumnsType } from "antd/es/table";
import ReactECharts from "echarts-for-react";
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

type DepartmentDistribution = {
  name: string;
  count: number;
};

const defaultSummary: DashboardSummary = {
  totalEmployees: 0, activeEmployees: 0, departments: 0,
  openPayrollPeriods: 0, pendingLeaves: 0
};

const activityColumns: ColumnsType<DashboardActivity> = [
  { title: "Loại", dataIndex: "type", width: 180 },
  { title: "Nội dung", dataIndex: "message" },
  { title: "Thời gian", dataIndex: "timestamp", width: 220 }
];

const { Text } = Typography;

const activityEmptyText = (
  <Empty image={Empty.PRESENTED_IMAGE_SIMPLE}
    description={<div className="dashboard-empty"><Text strong>Không có hoạt động gần đây</Text>
    <Text type="secondary">Các sự kiện vận hành mới sẽ xuất hiện tại đây.</Text></div>} />
);

export default function DashboardPage() {
  const [summary, setSummary] = useState<DashboardSummary>(defaultSummary);
  const [activities, setActivities] = useState<DashboardActivity[]>([]);
  const [headcounts, setHeadcounts] = useState<DepartmentHeadcount[]>([]);
  const [distribution, setDistribution] = useState<DepartmentDistribution[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;
    async function load() {
      setLoading(true);
      setError(null);
      try {
        const [summaryR, activityR, headcountR, distR] = await Promise.all([
          apiClient.get<DashboardSummary>("/dashboard/summary"),
          apiClient.get<DashboardActivity[]>("/dashboard/activities"),
          apiClient.get<DepartmentHeadcount[]>("/dashboard/headcount-by-department"),
          apiClient.get<DepartmentDistribution[]>("/dashboard/department-distribution")
        ]);
        if (mounted) {
          setSummary({ ...defaultSummary, ...(summaryR.data ?? {}) });
          setActivities(Array.isArray(activityR.data) ? activityR.data : []);
          setHeadcounts(Array.isArray(headcountR.data) ? headcountR.data : []);
          setDistribution(Array.isArray(distR.data) ? distR.data : []);
        }
      } catch {
        if (mounted) setError("Không tải được dữ liệu tổng quan");
      } finally {
        if (mounted) setLoading(false);
      }
    }
    void load();
    return () => { mounted = false; };
  }, []);

  const pieOption = {
    tooltip: { trigger: 'item' as const },
    legend: { bottom: 0 },
    series: [{
      type: 'pie', radius: ['40%', '70%'],
      data: distribution.map(d => ({ name: d.name, value: d.count })),
      label: { show: true, formatter: '{b}: {c}' }
    }]
  };

  const barOption = {
    tooltip: { trigger: 'axis' as const },
    xAxis: { type: 'category', data: headcounts.map(h => h.departmentName) },
    yAxis: { type: 'value' },
    series: [{
      type: 'bar', data: headcounts.map(h => h.count),
      itemStyle: { color: '#1677ff', borderRadius: [4, 4, 0, 0] }
    }]
  };

  return (
    <>
      <div className="page-header">
        <h1>Tổng quan</h1>
        <p>Tóm tắt vận hành cho hệ thống quản trị nhân sự.</p>
      </div>

      {error && <Alert type="warning" showIcon message={error}
        description="Kiểm tra token, tenant và kết nối backend rồi tải lại trang."
        style={{ marginBottom: 16 }} />}

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
              <Statistic title="Đang làm việc" value={summary.activeEmployees}
                valueStyle={{ color: '#3f8600' }} />
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
              <Statistic title="Đơn nghỉ chờ duyệt" value={summary.pendingLeaves}
                valueStyle={{ color: summary.pendingLeaves > 0 ? '#cf1322' : undefined }} />
            </Skeleton>
          </Card>
        </Col>
      </Row>

      <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
        <Col xs={24} lg={12}>
          <Card title="Phân bố nhân viên theo phòng ban">
            {distribution.length > 0
              ? <ReactECharts option={pieOption} style={{ height: 320 }} />
              : <Empty description="Chưa có dữ liệu" />}
          </Card>
        </Col>
        <Col xs={24} lg={12}>
          <Card title="Số lượng nhân viên theo phòng ban">
            {headcounts.length > 0
              ? <ReactECharts option={barOption} style={{ height: 320 }} />
              : <Empty description="Chưa có dữ liệu" />}
          </Card>
        </Col>
      </Row>

      <Table style={{ marginTop: 16 }}
        className="dashboard-activity-table"
        rowKey={(row) => `${row.type}-${row.timestamp}`}
        loading={loading} dataSource={activities}
        columns={activityColumns} pagination={false}
        locale={{ emptyText: activityEmptyText }} />
    </>
  );
}
