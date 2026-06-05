import { Alert, Button, Drawer, Form, Input, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { StatusTag } from "../../shared/ui/StatusTag";
import InterviewFeedback from "./InterviewFeedback";
import InterviewScheduler from "./InterviewScheduler";
import RecruitmentKanban from "./RecruitmentKanban";

type Candidate = {
  id: string;
  fullName: string;
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

type Department = {
  id: string;
  code: string;
  name: string;
};

type Interview = {
  id: string;
  applicationId: string;
  interviewerId: string;
  scheduledAt: string;
  location: string;
  meetingLink: string;
  feedback: string;
  rating: number;
  status: string;
};

function usePagedData<T>(path: string, errorMessage: string) {
  const [items, setItems] = useState<T[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const loadData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<T>>(path, {
        params: { page: 0, size: 10 }
      });
      setItems(response.data.items ?? []);
    } catch {
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  }, [errorMessage, path]);

  useEffect(() => {
    void loadData();
  }, [loadData]);

  return { error, items, loading, reload: loadData };
}

export default function RecruitmentPage() {
  const { t } = useTranslation();
  const candidates = usePagedData<Candidate>(
    "/candidates",
    t("pages.recruitment.candidateLoadError")
  );
  const postings = usePagedData<JobPosting>(
    "/job-postings",
    t("pages.recruitment.postingLoadError")
  );
  const applications = usePagedData<RecruitmentApplication>(
    "/applications",
    t("pages.recruitment.applicationLoadError")
  );
  const [departments, setDepartments] = useState<Department[]>([]);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [editingCandidate, setEditingCandidate] = useState<Candidate | null>(null);
  const [editingPosting, setEditingPosting] = useState<JobPosting | null>(null);
  const [convertingApplication, setConvertingApplication] = useState<RecruitmentApplication | null>(null);
  const [candidateForm] = Form.useForm<{ fullName: string }>();
  const [postingForm] = Form.useForm<{ title: string }>();
  const [convertForm] = Form.useForm<{ employeeNo: string; departmentId: string }>();
  const [interviewOpen, setInterviewOpen] = useState(false);
  const [feedbackInterviewId, setFeedbackInterviewId] = useState<string | null>(null);
  const [interviewList, setInterviewList] = useState<Interview[]>([]);
  const [interviewLoading, setInterviewLoading] = useState(false);

  const loadDepartments = useCallback(async () => {
    try {
      const response = await apiClient.get<PageResponse<Department>>("/departments", {
        params: { page: 0, size: 100 }
      });
      setDepartments(response.data.items ?? []);
    } catch {
      setDepartments([]);
    }
  }, []);

  useEffect(() => {
    void loadDepartments();
  }, [loadDepartments]);

  const loadInterviews = useCallback(async () => {
    setInterviewLoading(true);
    try {
      const res = await apiClient.get<Interview[]>("/interviews");
      setInterviewList(res.data ?? []);
    } catch { setInterviewList([]); }
    finally { setInterviewLoading(false); }
  }, []);

  useEffect(() => { void loadInterviews(); }, [loadInterviews]);

  const intervieweeColumns = useMemo<ColumnsType<Interview>>(() => [
    { title: t("pages.recruitment.application"), dataIndex: "applicationId", width: 120, render: (v: string) => v.slice(0, 8) },
    { title: t("pages.recruitment.interviewer"), dataIndex: "interviewerId", width: 120, render: (v: string) => v?.slice(0, 8) ?? "-" },
    { title: t("pages.recruitment.scheduledAt"), dataIndex: "scheduledAt", width: 180 },
    { title: t("pages.recruitment.location"), dataIndex: "location", width: 120, render: (v: string) => v ?? "-" },
    { title: "Rating", dataIndex: "rating", width: 70, render: (v: number) => v ?? "-" },
    {
      title: t("common.status"), dataIndex: "status", width: 130,
      render: (v: string) => <StatusTag value={v} />
    },
    {
      title: "", key: "actions", width: 100,
      render: (_, row) => (
        <Button size="small" onClick={() => setFeedbackInterviewId(row.id)}>{t("pages.recruitment.feedback")}</Button>
      )
    }
  ], [t]);

  const openCandidateEdit = (candidate: Candidate) => {
    setEditingCandidate(candidate);
    candidateForm.setFieldsValue({ fullName: candidate.fullName });
  };

  const openPostingEdit = (posting: JobPosting) => {
    setEditingPosting(posting);
    postingForm.setFieldsValue({ title: posting.title });
  };

  const updateCandidate = async (values: { fullName: string }) => {
    if (!editingCandidate) {
      return;
    }

    setSaving(true);
    setError(null);
    try {
      await apiClient.put(`/candidates/${editingCandidate.id}`, { fullName: values.fullName.trim() });
      setEditingCandidate(null);
      candidateForm.resetFields();
      await candidates.reload();
    } catch {
      setError(t("pages.recruitment.candidateUpdateError"));
    } finally {
      setSaving(false);
    }
  };

  const updatePosting = async (values: { title: string }) => {
    if (!editingPosting) {
      return;
    }

    setSaving(true);
    setError(null);
    try {
      await apiClient.put(`/job-postings/${editingPosting.id}`, { title: values.title.trim() });
      setEditingPosting(null);
      postingForm.resetFields();
      await postings.reload();
    } catch {
      setError(t("pages.recruitment.postingUpdateError"));
    } finally {
      setSaving(false);
    }
  };

  const convertApplication = async (values: { employeeNo: string; departmentId: string }) => {
    if (!convertingApplication) {
      return;
    }

    setSaving(true);
    setError(null);
    try {
      await apiClient.post(`/recruitment/applications/${convertingApplication.id}/convert`, {
        employeeNo: values.employeeNo.trim(),
        departmentId: values.departmentId
      });
      setConvertingApplication(null);
      convertForm.resetFields();
      await applications.reload();
    } catch {
      setError(t("pages.recruitment.convertError"));
    } finally {
      setSaving(false);
    }
  };

  const candidateColumns = useMemo<ColumnsType<Candidate>>(
    () => [
      { title: t("pages.recruitment.candidate"), dataIndex: "fullName" },
      {
        title: t("common.actions"),
        key: "actions",
        width: 160,
        render: (_, row) => (
          <Button size="small" onClick={() => openCandidateEdit(row)}>
            {t("pages.recruitment.editCandidate")}
          </Button>
        )
      }
    ],
    [t]
  );

  const postingColumns = useMemo<ColumnsType<JobPosting>>(
    () => [
      { title: t("pages.recruitment.posting"), dataIndex: "title" },
      {
        title: t("common.status"),
        dataIndex: "status",
        width: 160,
        render: (value?: string) => (value ? <StatusTag value={value} /> : null)
      },
      {
        title: t("common.actions"),
        key: "actions",
        width: 180,
        render: (_, row) => (
          <Button size="small" onClick={() => openPostingEdit(row)}>
            {t("pages.recruitment.editPosting")}
          </Button>
        )
      }
    ],
    [t]
  );

  const applicationColumns = useMemo<ColumnsType<RecruitmentApplication>>(
    () => [
      {
        title: t("pages.recruitment.application"),
        dataIndex: "id",
        width: 140,
        render: (value: string) => value.slice(0, 8)
      },
      { title: t("pages.recruitment.candidate"), dataIndex: "candidateName", render: (value?: string) => value ?? t("pages.recruitment.missingApiData") },
      { title: t("common.position"), dataIndex: "jobTitle", render: (value?: string) => value ?? t("pages.recruitment.missingApiData") },
      {
        title: t("common.status"),
        dataIndex: "status",
        width: 180,
        render: (value: string) => <StatusTag value={value} />
      },
      {
        title: t("common.actions"),
        key: "actions",
        width: 210,
        render: (_, row) => (
          <Button
            size="small"
            disabled={row.status !== "OFFER_ACCEPTED" || saving}
            onClick={() => {
              setConvertingApplication(row);
              convertForm.resetFields();
            }}
          >
            {t("pages.recruitment.convertToEmployee")}
          </Button>
        )
      }
    ],
    [convertForm, saving, t]
  );

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.recruitment.title")}</h1>
        <p>{t("pages.recruitment.subtitle")}</p>
      </div>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <Tabs
        items={[
          {
            key: "candidates",
            label: t("pages.recruitment.candidates"),
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
            label: t("pages.recruitment.postings"),
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
            label: t("pages.recruitment.applications"),
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
          },
          {
            key: "kanban",
            label: "Kanban",
            children: (
              <>
                {applications.error ? <Alert type="warning" showIcon message={applications.error} style={{ marginBottom: 16 }} /> : null}
                <RecruitmentKanban applications={applications.items} />
              </>
            )
          },
          {
            key: "interviews",
            label: t("pages.recruitment.interviews"),
            children: (
              <>
                <Space style={{ marginBottom: 16 }}>
                  <Button type="primary" onClick={() => setInterviewOpen(true)}>{t("pages.recruitment.scheduleInterview")}</Button>
                </Space>
                <AppTable<Interview> rowKey="id" loading={interviewLoading} columns={intervieweeColumns} dataSource={interviewList} pagination={false} />
              </>
            )
          }
        ]}
      />

      <FormDrawer open={Boolean(editingCandidate)} title={t("pages.recruitment.updateCandidate")} onClose={() => setEditingCandidate(null)}>
        <Form form={candidateForm} layout="vertical" onFinish={updateCandidate}>
          <Form.Item label={t("pages.employees.fullName")} name="fullName" htmlFor="candidate-name" rules={[{ required: true, message: t("pages.recruitment.enterFullName") }]}>
            <Input id="candidate-name" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            {t("pages.employees.saveChanges")}
          </Button>
        </Form>
      </FormDrawer>

      <FormDrawer open={Boolean(editingPosting)} title={t("pages.recruitment.updatePosting")} onClose={() => setEditingPosting(null)}>
        <Form form={postingForm} layout="vertical" onFinish={updatePosting}>
          <Form.Item label={t("pages.announcements.announcementTitle")} name="title" htmlFor="posting-title" rules={[{ required: true, message: t("pages.recruitment.enterTitle") }]}>
            <Input id="posting-title" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            {t("pages.employees.saveChanges")}
          </Button>
        </Form>
      </FormDrawer>

      <FormDrawer open={Boolean(convertingApplication)} title={t("pages.recruitment.convertToEmployee")} onClose={() => setConvertingApplication(null)}>
        <Form form={convertForm} layout="vertical" onFinish={convertApplication}>
          <Form.Item label={t("pages.employees.employeeNo")} name="employeeNo" htmlFor="convert-employee-no" rules={[{ required: true, message: t("pages.recruitment.enterEmployeeNo") }]}>
            <Input id="convert-employee-no" />
          </Form.Item>
          <Form.Item label={t("common.department")} name="departmentId" htmlFor="convert-department" rules={[{ required: true, message: t("pages.recruitment.chooseDepartment") }]}>
            <Select
              id="convert-department"
              placeholder={t("pages.recruitment.chooseDepartment")}
              options={departments.map((department) => ({
                value: department.id,
                label: `${department.code} - ${department.name}`
              }))}
            />
          </Form.Item>
          <Space>
            <Button type="primary" htmlType="submit" loading={saving} disabled={!departments.length}>
              {t("pages.recruitment.convert")}
            </Button>
          </Space>
        </Form>
      </FormDrawer>
      <Drawer title={t("pages.recruitment.scheduleInterview")} width="min(480px, calc(100vw - 32px))" open={interviewOpen} onClose={() => setInterviewOpen(false)} destroyOnClose>
        <InterviewScheduler open={interviewOpen} applications={applications.items} onClose={() => setInterviewOpen(false)} onSaved={() => { setInterviewOpen(false); void loadInterviews(); }} />
      </Drawer>

      <Drawer title={t("pages.recruitment.interviewFeedback")} width="min(420px, calc(100vw - 32px))" open={!!feedbackInterviewId} onClose={() => setFeedbackInterviewId(null)} destroyOnClose>
        <InterviewFeedback interviewId={feedbackInterviewId} open={!!feedbackInterviewId} onClose={() => setFeedbackInterviewId(null)} onSaved={() => { setFeedbackInterviewId(null); void loadInterviews(); }} />
      </Drawer>
    </>
  );
}
