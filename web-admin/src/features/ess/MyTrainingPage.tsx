import { Card, Col, Progress, Row, Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';
import { StatusTag } from '../../shared/ui/StatusTag';

const { Title } = Typography;

type Enrollment = {
  id: string; courseId: string; progress: number; status: string;
};

type Course = {
  id: string; title: string; description: string;
  category: string; instructorName: string;
};

export default function MyTrainingPage() {
  const { t } = useTranslation();
  const [enrollments, setEnrollments] = useState<Enrollment[]>([]);
  const [courses, setCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const empId = getEmployeeId();
        const [eRes, cRes] = await Promise.all([
          apiClient.get<Enrollment[]>(`/training/enrollments/employee/${empId}`, {
            headers: { 'X-Employee-Id': empId }
          }),
          apiClient.get<Course[]>('/training/courses', {
            headers: { 'X-Employee-Id': empId }
          })
        ]);
        if (mounted) {
          setEnrollments(Array.isArray(eRes.data) ? eRes.data : []);
          setCourses(Array.isArray(cRes.data) ? cRes.data : []);
        }
      } finally { if (mounted) setLoading(false); }
    })();
    return () => { mounted = false; };
  }, []);

  const eCols: ColumnsType<Enrollment> = [
    { title: t('ess.courseId'), dataIndex: 'courseId' },
    { title: t('pages.training.progress'), dataIndex: 'progress', render: (v: number) => <Progress percent={v} size="small" /> },
    { title: t('common.status'), dataIndex: 'status', render: (v: string) => <StatusTag value={v} /> }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('nav.training')}</Title></div>
      <Row gutter={[16, 16]}>
        {courses.map(c => (
          <Col xs={24} sm={12} lg={8} key={c.id}>
            <Card title={c.title} loading={loading}>
              <p>{c.description}</p>
              <p>{t('ess.instructorPrefix', { name: c.instructorName })}</p>
              <p>{t('ess.categoryPrefix', { category: c.category })}</p>
            </Card>
          </Col>
        ))}
      </Row>
      <Title level={4} style={{ marginTop: 24 }}>{t('ess.myCourses')}</Title>
      <Table rowKey="id" loading={loading} dataSource={enrollments} columns={eCols} />
    </div>
  );
}
