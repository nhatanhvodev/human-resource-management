import { Alert, Descriptions, Drawer, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useState } from "react";
import { useTranslation } from "react-i18next";

import type { UseQueryResult } from "@tanstack/react-query";

import { API } from "../../shared/api/endpoints";
// NOTE: `as UseQueryResult<...>` restores useApiQuery's documented return type, which currently
// degrades under the installed @tanstack/react-query 5.102.8 (overload error inside query.ts).
// The cast is type-only and has zero runtime effect.
import { useApiQuery } from "../../shared/api/query";
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

export default function PerformancePage() {
  const { t } = useTranslation();
  const [activeTab, setActiveTab] = useState("cycles");
  const [selectedCycle, setSelectedCycle] = useState<AppraisalCycle | null>(null);
  const [openReviews, setOpenReviews] = useState(false);

  const cyclesQuery = useApiQuery<PageResponse<AppraisalCycle>>(["performance", "cycles"], API.PERFORMANCE.CYCLES, {
    config: { params: { page: 0, size: 20 } }
  }) as UseQueryResult<PageResponse<AppraisalCycle>, unknown>;
  // Detail queries run on demand when the drawer opens (enabled on selection),
  // replacing the manual fetch previously issued inside openCycleReviews.
  const reviewsQuery = useApiQuery<PageResponse<PerformanceReview>>(
    ["performance", "reviews", selectedCycle?.id],
    selectedCycle ? `${API.PERFORMANCE.CYCLES}/${selectedCycle.id}/reviews` : API.PERFORMANCE.CYCLES,
    { config: { params: { page: 0, size: 200 } }, enabled: !!selectedCycle }
  ) as UseQueryResult<PageResponse<PerformanceReview>, unknown>;
  const kpisQuery = useApiQuery<PageResponse<KPI>>(
    ["performance", "kpis", selectedCycle?.id],
    selectedCycle ? `${API.PERFORMANCE.CYCLES}/${selectedCycle.id}/kpis` : API.PERFORMANCE.CYCLES,
    { config: { params: { page: 0, size: 500 } }, enabled: !!selectedCycle }
  ) as UseQueryResult<PageResponse<KPI>, unknown>;

  const cycles = cyclesQuery.data?.items ?? [];
  const loading = cyclesQuery.isLoading;
  const error = cyclesQuery.isError ? t("pages.performance.loadError") : null;
  const reviews = reviewsQuery.data?.items ?? [];
  const kpis = kpisQuery.data?.items ?? [];
  const loadingReviews = reviewsQuery.isFetching || kpisQuery.isFetching;

  const openCycleReviews = (cycle: AppraisalCycle) => {
    setSelectedCycle(cycle);
    setOpenReviews(true);
  };

  const cycleColumns: ColumnsType<AppraisalCycle> = [
    { title: t("pages.performance.cycleName"), dataIndex: "name", width: 180 },
    { title: t("pages.performance.cycleType"), dataIndex: "cycleType", width: 100 },
    { title: t("common.fromDate"), dataIndex: "startDate", width: 130 },
    { title: t("common.toDate"), dataIndex: "endDate", width: 130 },
    {
      title: t("common.status"),
      dataIndex: "status",
      width: 130,
      render: (v: string) => <StatusTag value={v} />
    },
  ];

  const reviewColumns: ColumnsType<PerformanceReview> = [
    { title: t("pages.performance.reviewerType"), dataIndex: "reviewerType", width: 130 },
    { title: t("pages.performance.score"), dataIndex: "overallScore", width: 80, render: (v?: number) => v?.toFixed(1) ?? "-" },
    { title: t("common.status"), dataIndex: "status", width: 130, render: (v: string) => <StatusTag value={v} /> },
    { title: t("pages.performance.submittedAt"), dataIndex: "submittedAt", width: 180 },
  ];

  const kpiColumns: ColumnsType<KPI> = [
    { title: t("pages.performance.criterion"), dataIndex: "title" },
    { title: t("common.description"), dataIndex: "description", ellipsis: true },
    { title: t("pages.performance.targetScore"), dataIndex: "targetScore", width: 120, render: (v: number) => v.toFixed(1) },
    { title: t("pages.performance.actualScore"), dataIndex: "actualScore", width: 120, render: (v?: number) => v?.toFixed(1) ?? "-" },
    { title: t("pages.performance.weight"), dataIndex: "weight", width: 100, render: (v: number) => `${v}%` },
  ];

  const cycleTypeLabel = (value: string) => {
    const map: Record<string, string> = {
      Q1: t("pages.performance.q1"),
      Q2: t("pages.performance.q2"),
      Q3: t("pages.performance.q3"),
      Q4: t("pages.performance.q4"),
      H1: t("pages.performance.h1"),
      H2: t("pages.performance.h2"),
      YEARLY: t("pages.performance.yearly")
    };
    return map[value] ?? value;
  };

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.performance.title")}</h1>
        <p>{t("pages.performance.subtitle")}</p>
      </div>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <Tabs activeKey={activeTab} onChange={setActiveTab} items={[
        {
          key: "cycles",
          label: t("pages.performance.cycles"),
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
                    <a onClick={() => void openCycleReviews(row)}>{t("pages.performance.viewDetails")}</a>
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
          label: t("pages.performance.reviews"),
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
        title={selectedCycle ? `${selectedCycle.name} - ${cycleTypeLabel(selectedCycle.cycleType)}` : t("pages.performance.cycleDetail")}
        width="min(900px, calc(100vw - 32px))"
        open={openReviews}
        onClose={() => { setOpenReviews(false); setSelectedCycle(null); }}
      >
        {selectedCycle && (
          <Descriptions bordered column={2} size="small" style={{ marginBottom: 16 }}>
            <Descriptions.Item label={t("common.status")}>
              <StatusTag value={selectedCycle.status} />
            </Descriptions.Item>
            <Descriptions.Item label={t("pages.performance.period")}>
              {selectedCycle.startDate} - {selectedCycle.endDate}
            </Descriptions.Item>
          </Descriptions>
        )}
        <h3>{t("pages.performance.reviewsCount", { count: reviews.length })}</h3>
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
