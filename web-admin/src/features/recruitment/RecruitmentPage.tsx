import { Alert, Button, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useEffect, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { StatusTag } from "../../shared/ui/StatusTag";

type Candidate = {
  id: string;
  fullName: string;
  email?: string;
};

type JobPosting = {
  id: string;
  title: string;
  status?: string;
};

type RecruitmentApplication = {
  id: string;
  candidateName?: string;
  jobTitle?: string;
  status: string;
};

function usePagedData<T>(path: string) {
  const [items, setItems] = useState<T[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let mounted = true;

    async function loadData() {
      setLoading(true);
      setError(null);
      try {
        const response = await apiClient.get<PageResponse<T>>(path, {
          params: { page: 0, size: 10 }
        });
        if (mounted) {
          setItems(response.data.items ?? []);
        }
      } catch {
        if (mounted) {
          setError("Unable to load recruitment data. Check token, tenant, and backend connectivity.");
        }
      } finally {
        if (mounted) {
          setLoading(false);
        }
      }
    }

    void loadData();

    return () => {
      mounted = false;
    };
  }, [path]);

  return { error, items, loading };
}

const candidateColumns: ColumnsType<Candidate> = [
  { title: "Candidate", dataIndex: "fullName" },
  { title: "Email", dataIndex: "email" },
  {
    title: "Actions",
    key: "actions",
    width: 160,
    render: () => <Button size="small">Edit</Button>
  }
];

const postingColumns: ColumnsType<JobPosting> = [
  { title: "Job Posting", dataIndex: "title" },
  {
    title: "Status",
    dataIndex: "status",
    width: 160,
    render: (value?: string) => (value ? <StatusTag value={value} /> : null)
  },
  {
    title: "Actions",
    key: "actions",
    width: 160,
    render: () => <Button size="small">Edit</Button>
  }
];

const applicationColumns: ColumnsType<RecruitmentApplication> = [
  { title: "Candidate", dataIndex: "candidateName" },
  { title: "Job", dataIndex: "jobTitle" },
  {
    title: "Status",
    dataIndex: "status",
    width: 180,
    render: (value: string) => <StatusTag value={value} />
  },
  {
    title: "Actions",
    key: "actions",
    width: 180,
    render: () => (
      <Space>
        <Button size="small">Convert</Button>
      </Space>
    )
  }
];

export default function RecruitmentPage() {
  const candidates = usePagedData<Candidate>("/candidates");
  const postings = usePagedData<JobPosting>("/job-postings");
  const applications = usePagedData<RecruitmentApplication>("/applications");

  return (
    <>
      <div className="page-header">
        <h1>Recruitment</h1>
        <p>Manage candidates, job postings, and application conversion flows.</p>
      </div>

      <Tabs
        items={[
          {
            key: "candidates",
            label: "Candidates",
            children: (
              <>
                {candidates.error ? <Alert type="warning" showIcon message={candidates.error} style={{ marginBottom: 16 }} /> : null}
                <AppTable<Candidate>
                  rowKey="id"
                  loading={candidates.loading}
                  columns={candidateColumns}
                  dataSource={candidates.items}
                  pagination={false}
                />
              </>
            )
          },
          {
            key: "postings",
            label: "Job Postings",
            children: (
              <>
                {postings.error ? <Alert type="warning" showIcon message={postings.error} style={{ marginBottom: 16 }} /> : null}
                <AppTable<JobPosting>
                  rowKey="id"
                  loading={postings.loading}
                  columns={postingColumns}
                  dataSource={postings.items}
                  pagination={false}
                />
              </>
            )
          },
          {
            key: "applications",
            label: "Applications",
            children: (
              <>
                {applications.error ? <Alert type="warning" showIcon message={applications.error} style={{ marginBottom: 16 }} /> : null}
                <AppTable<RecruitmentApplication>
                  rowKey="id"
                  loading={applications.loading}
                  columns={applicationColumns}
                  dataSource={applications.items}
                  pagination={false}
                />
              </>
            )
          }
        ]}
      />
    </>
  );
}
