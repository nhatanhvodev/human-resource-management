import { Alert, Descriptions, Drawer, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { StatusTag } from "../../shared/ui/StatusTag";

type AppraisalCycle = {
  id: string;
  name: string;
  cycleType: string;
  startDate: string;
  endDate: string;
  status: string;
};

type PerformanceReview = {
  id: string;
  cycleName?: string;
  employeeId?: string;
  reviewerType: string;
  reviewerId?: string;
  overallScore?: number;
  strengths?: string;
  improvements?: string;
  status: string;
  submittedAt?: string;
};

type KPI = {
  id: string;
  employeeId?: string;
  title: string;
  description?: string;
  targetScore: number;
  actualScore?: number;
  weight: number;
};

const cycleColumns: ColumnsType<AppraisalCycle> = [
  { title: "Tên chu kỳ", dataIndex: "name", width: 180 },
  { title: "Loại", dataIndex: "cycleType", width: 100 },
  { title: "Từ ngày", dataIndex: "startDate", width: 130 },
  { title: "Đến ngày", dataIndex: "endDate", width: 130 },
  {
    title: "Trạng thái",
    dataIndex: "status",
    width: 130,
    render: (v: string) => <StatusTag value={v} />
  },
];

const reviewColumns: ColumnsType<PerformanceReview> = [
  { title: "Loại đánh giá", dataIndex: "reviewerType", width: 130 },
  { title: "Điểm", dataIndex: "overallScore", width: 80, render: (v?: number) => v?.toFixed(1) ?? "-" },
  { title: "Trạng thái", dataIndex: "status", width: 130, render: (v: string) => <StatusTag value={v} /> },
  { title: "Ngày nộp", dataIndex: "submittedAt", width: 180 },
];

const kpiColumns: ColumnsType<KPI> = [
  { title: "Tiêu chí", dataIndex: "title" },
  { title: "Mô tả", dataIndex: "description", ellipsis: true },
  { title: "Điểm mục tiêu", dataIndex: "targetScore", width: 120, render: (v: number) => v.toFixed(1) },
  { title: "Điểm thực tế", dataIndex: "actualScore", width: 120, render: (v?: number) => v?.toFixed(1) ?? "-" },
  { title: "Trọng số", dataIndex: "weight", width: 100, render: (v: number) => `${v}%` },
];

export default function PerformancePage() {
  const [activeTab, setActiveTab] = useState("cycles");
  const [cycles, setCycles] = useState<AppraisalCycle[]>([]);
  const [reviews, setReviews] = useState<PerformanceReview[]>([]);
  const [kpis, setKpis] = useState<KPI[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [selectedCycle, setSelectedCycle] = useState<AppraisalCycle | null>(null);
  const [openReviews, setOpenReviews] = useState(false);
  const [loadingReviews, setLoadingReviews] = useState(false);

  const loadCycles = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await apiClient.get<PageResponse<AppraisalCycle>>("/performance/cycles", {
        params: { page: 0, size: 20 }
      });
      setCycles(res.data.items ?? []);
    } catch {
      setError("Không tải được danh sách chu kỳ đánh giá.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { void loadCycles(); }, [loadCycles]);

  const openCycleReviews = async (cycle: AppraisalCycle) => {
    setSelectedCycle(cycle);
    setOpenReviews(true);
    setLoadingReviews(true);
    try {
      const [revRes, kpiRes] = await Promise.all([
        apiClient.get<PageResponse<PerformanceReview>>(`/performance/cycles/${cycle.id}/reviews`, { params: { page: 0, size: 200 } }),
        apiClient.get<PageResponse<KPI>>(`/performance/cycles/${cycle.id}/kpis`, { params: { page: 0, size: 500 } })
      ]);
      setReviews(revRes.data.items ?? []);
      setKpis(kpiRes.data.items ?? []);
    } catch {
      setReviews([]);
      setKpis([]);
    } finally {
      setLoadingReviews(false);
    }
  };

  const cycleTypeLabel = (t: string) => {
    const map: Record<string, string> = { Q1: "Quý 1", Q2: "Quý 2", Q3: "Quý 3", Q4: "Quý 4", H1: "Nửa đầu năm", H2: "Nửa cuối năm", YEARLY: "Cả năm" };
    return map[t] ?? t;
  };

  return (
    <>
      <div className="page-header">
        <h1>Đánh giá</h1>
        <p>Quản lý chu kỳ đánh giá, theo dõi kết quả đánh giá nhân viên và KPI.</p>
      </div>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <Tabs activeKey={activeTab} onChange={setActiveTab} items={[
        {
          key: "cycles",
          label: "Chu kỳ đánh giá",
          children: (
            <AppTable<AppraisalCycle>
              rowKey="id"
              loading={loading}
              columns={[
                ...cycleColumns,
                {
                  title: "",
                  key: "view",
                  width: 100,
                  render: (_, row) => (
                    <a onClick={() => void openCycleReviews(row)}>Xem chi tiết</a>
                  )
                }
              ]}
              dataSource={cycles}
              pagination={false}
            />
          )
        },
        {
          key: "reviews",
          label: "Đánh giá cá nhân",
          children: (
            <AppTable<PerformanceReview>
              rowKey="id"
              loading={loading}
              columns={reviewColumns}
              dataSource={reviews}
              pagination={false}
            />
          )
        },
        {
          key: "kpis",
          label: "KPI",
          children: (
            <AppTable<KPI>
              rowKey="id"
              loading={loading}
              columns={kpiColumns}
              dataSource={kpis}
              pagination={false}
            />
          )
        }
      ]} />

      <Drawer
        title={selectedCycle ? `${selectedCycle.name} — ${cycleTypeLabel(selectedCycle.cycleType)}` : "Chi tiết chu kỳ"}
        width="min(900px, calc(100vw - 32px))"
        open={openReviews}
        onClose={() => { setOpenReviews(false); setSelectedCycle(null); }}
      >
        {selectedCycle && (
          <Descriptions bordered column={2} size="small" style={{ marginBottom: 16 }}>
            <Descriptions.Item label="Trạng thái">
              <StatusTag value={selectedCycle.status} />
            </Descriptions.Item>
            <Descriptions.Item label="Thời gian">
              {selectedCycle.startDate} → {selectedCycle.endDate}
            </Descriptions.Item>
          </Descriptions>
        )}
        <h3>Đánh giá ({reviews.length})</h3>
        <AppTable<PerformanceReview>
          rowKey="id"
          loading={loadingReviews}
          columns={reviewColumns}
          dataSource={reviews}
          pagination={false}
        />
        <h3 style={{ marginTop: 16 }}>KPI ({kpis.length})</h3>
        <AppTable<KPI>
          rowKey="id"
          loading={loadingReviews}
          columns={kpiColumns}
          dataSource={kpis}
          pagination={false}
        />
      </Drawer>
    </>
  );
}
