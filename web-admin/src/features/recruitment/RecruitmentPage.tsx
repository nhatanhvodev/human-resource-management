import { Alert, Button, Form, Input, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { StatusTag } from "../../shared/ui/StatusTag";

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
  const candidates = usePagedData<Candidate>(
    "/candidates",
    "Không tải được danh sách ứng viên. Kiểm tra token, tenant và kết nối backend."
  );
  const postings = usePagedData<JobPosting>(
    "/job-postings",
    "Không tải được danh sách tin tuyển dụng. Kiểm tra token, tenant và kết nối backend."
  );
  const applications = usePagedData<RecruitmentApplication>(
    "/applications",
    "Không tải được hồ sơ ứng tuyển. Kiểm tra token, tenant và kết nối backend."
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
      setError("Không cập nhật được ứng viên. Kiểm tra họ tên hoặc quyền cập nhật.");
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
      setError("Không cập nhật được tin tuyển dụng. Kiểm tra tiêu đề hoặc quyền cập nhật.");
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
      setError("Không chuyển được hồ sơ thành nhân viên. Hồ sơ cần ở trạng thái đã nhận đề nghị và có phòng ban hợp lệ.");
    } finally {
      setSaving(false);
    }
  };

  const candidateColumns = useMemo<ColumnsType<Candidate>>(
    () => [
      { title: "Ứng viên", dataIndex: "fullName" },
      {
        title: "Thao tác",
        key: "actions",
        width: 160,
        render: (_, row) => (
          <Button size="small" onClick={() => openCandidateEdit(row)}>
            Sửa ứng viên
          </Button>
        )
      }
    ],
    []
  );

  const postingColumns = useMemo<ColumnsType<JobPosting>>(
    () => [
      { title: "Tin tuyển dụng", dataIndex: "title" },
      {
        title: "Trạng thái",
        dataIndex: "status",
        width: 160,
        render: (value?: string) => (value ? <StatusTag value={value} /> : null)
      },
      {
        title: "Thao tác",
        key: "actions",
        width: 180,
        render: (_, row) => (
          <Button size="small" onClick={() => openPostingEdit(row)}>
            Sửa tin
          </Button>
        )
      }
    ],
    []
  );

  const applicationColumns = useMemo<ColumnsType<RecruitmentApplication>>(
    () => [
      {
        title: "Hồ sơ",
        dataIndex: "id",
        width: 140,
        render: (value: string) => value.slice(0, 8)
      },
      { title: "Ứng viên", dataIndex: "candidateName", render: (value?: string) => value ?? "Chưa có dữ liệu từ API" },
      { title: "Vị trí", dataIndex: "jobTitle", render: (value?: string) => value ?? "Chưa có dữ liệu từ API" },
      {
        title: "Trạng thái",
        dataIndex: "status",
        width: 180,
        render: (value: string) => <StatusTag value={value} />
      },
      {
        title: "Thao tác",
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
            Chuyển thành nhân viên
          </Button>
        )
      }
    ],
    [convertForm, saving]
  );

  return (
    <>
      <div className="page-header">
        <h1>Tuyển dụng</h1>
        <p>Quản lý ứng viên, tin tuyển dụng và chuyển hồ sơ trúng tuyển thành nhân viên.</p>
      </div>

      {error ? <Alert type="warning" showIcon message={error} style={{ marginBottom: 16 }} /> : null}

      <Tabs
        items={[
          {
            key: "candidates",
            label: "Ứng viên",
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
            label: "Tin tuyển dụng",
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
            label: "Hồ sơ ứng tuyển",
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

      <FormDrawer open={Boolean(editingCandidate)} title="Cập nhật ứng viên" onClose={() => setEditingCandidate(null)}>
        <Form form={candidateForm} layout="vertical" onFinish={updateCandidate}>
          <Form.Item label="Họ và tên" name="fullName" htmlFor="candidate-name" rules={[{ required: true, message: "Nhập họ và tên" }]}>
            <Input id="candidate-name" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            Lưu thay đổi
          </Button>
        </Form>
      </FormDrawer>

      <FormDrawer open={Boolean(editingPosting)} title="Cập nhật tin tuyển dụng" onClose={() => setEditingPosting(null)}>
        <Form form={postingForm} layout="vertical" onFinish={updatePosting}>
          <Form.Item label="Tiêu đề" name="title" htmlFor="posting-title" rules={[{ required: true, message: "Nhập tiêu đề" }]}>
            <Input id="posting-title" />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving}>
            Lưu thay đổi
          </Button>
        </Form>
      </FormDrawer>

      <FormDrawer open={Boolean(convertingApplication)} title="Chuyển thành nhân viên" onClose={() => setConvertingApplication(null)}>
        <Form form={convertForm} layout="vertical" onFinish={convertApplication}>
          <Form.Item label="Mã nhân viên" name="employeeNo" htmlFor="convert-employee-no" rules={[{ required: true, message: "Nhập mã nhân viên" }]}>
            <Input id="convert-employee-no" />
          </Form.Item>
          <Form.Item label="Phòng ban" name="departmentId" htmlFor="convert-department" rules={[{ required: true, message: "Chọn phòng ban" }]}>
            <Select
              id="convert-department"
              placeholder="Chọn phòng ban"
              options={departments.map((department) => ({
                value: department.id,
                label: `${department.code} - ${department.name}`
              }))}
            />
          </Form.Item>
          <Space>
            <Button type="primary" htmlType="submit" loading={saving} disabled={!departments.length}>
              Chuyển đổi
            </Button>
          </Space>
        </Form>
      </FormDrawer>
    </>
  );
}
