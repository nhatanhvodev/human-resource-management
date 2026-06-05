import { ArrowLeftOutlined } from "@ant-design/icons";
import { Alert, Button, Progress, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { useParams, useNavigate } from "react-router-dom";
import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { StatusTag } from "../../shared/ui/StatusTag";

type Course = { id: string; title: string; description: string; category: string; durationHours: number; instructorName: string; startDate: string; endDate: string };
type Enrollment = { id: string; courseId: string; employeeId: string; progress: number; status: string; enrolledAt: string };
type Employee = { id: string; employeeNo: string; fullName: string };

export default function CourseDetailPage() {
  const { t } = useTranslation();
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [course, setCourse] = useState<Course | null>(null);
  const [enrollments, setEnrollments] = useState<Enrollment[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [loading, setLoading] = useState(false);

  const load = useCallback(async () => {
    if (!id) return;
    setLoading(true);
    try {
      const coursesRes = await apiClient.get<PageResponse<Course>>("/training/courses", { params: { page: 0, size: 100 } });
      const found = (coursesRes.data.items ?? []).find(c => c.id === id) ?? null;
      setCourse(found);

      const enrollRes = await apiClient.get<Enrollment[]>(`/training/enrollments/course/${id}`);
      setEnrollments(enrollRes.data ?? []);

      const empRes = await apiClient.get<PageResponse<Employee>>("/employees", { params: { page: 0, size: 200, status: "ACTIVE" } });
      setEmployees(empRes.data.items ?? []);
    } catch {} finally { setLoading(false); }
  }, [id]);

  useEffect(() => { void load(); }, [load]);

  const employeeById = useMemo(() => new Map(employees.map(e => [e.id, e])), [employees]);

  const columns = useMemo<ColumnsType<Enrollment>>(() => [
    {
      title: t("common.employee"), dataIndex: "employeeId",
      render: (v: string) => employeeById.get(v)?.fullName ?? v.slice(0, 8)
    },
    {
      title: t("pages.training.progress"), dataIndex: "progress", width: 200,
      render: (v: number) => <Progress percent={v} size="small" />
    },
    {
      title: t("common.status"), dataIndex: "status", width: 130,
      render: (v: string) => <StatusTag value={v} />
    },
    { title: t("pages.training.enrolledAt"), dataIndex: "enrolledAt", width: 180 }
  ], [employeeById, t]);

  if (!course) return <Alert message={t("pages.training.notFound")} type="warning" showIcon />;

  return (
    <>
      <Button icon={<ArrowLeftOutlined />} onClick={() => navigate("/training")} style={{ marginBottom: 16 }}>{t("pages.training.back")}</Button>
      <div className="page-header">
        <h1>{course.title}</h1>
        <p>{course.description ?? t("pages.training.noDescription")}</p>
      </div>
      <Tabs items={[
        {
          key: "info", label: t("pages.training.info"),
          children: (
            <div style={{ maxWidth: 480 }}>
              <table style={{ width: "100%" }}>
                <tbody>
                  <tr><td><strong>{t("pages.training.category")}</strong></td><td>{course.category ?? "-"}</td></tr>
                  <tr><td><strong>{t("pages.training.durationHours")}</strong></td><td>{course.durationHours ?? "-"}</td></tr>
                  <tr><td><strong>{t("pages.training.instructor")}</strong></td><td>{course.instructorName ?? "-"}</td></tr>
                  <tr><td><strong>{t("common.fromDate")}</strong></td><td>{course.startDate ?? "-"}</td></tr>
                  <tr><td><strong>{t("common.toDate")}</strong></td><td>{course.endDate ?? "-"}</td></tr>
                </tbody>
              </table>
            </div>
          )
        },
        {
          key: "enrollments", label: t("pages.training.students", { count: enrollments.length }),
          children: <AppTable<Enrollment> rowKey="id" loading={loading} columns={columns} dataSource={enrollments} pagination={false} />
        }
      ]} />
    </>
  );
}
