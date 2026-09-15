import { Card, Col, Progress, Row, Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useTranslation } from 'react-i18next';
import { asArray, useApiQuery } from '../../shared/api/query';
import type { PageResponse } from '../../shared/api/types';
import { useAccess } from '../../shared/auth/access';
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
  const { access } = useAccess();
  const empId = access?.employeeId ?? '';

  const enrollmentsQuery = useApiQuery<Enrollment[]>(
    ['self', 'enrollments', empId],
    `/training/enrollments/employee/${empId}`,
    { enabled: Boolean(empId) }
  );
  const coursesQuery = useApiQuery<PageResponse<Course>>(
    ['training', 'courses'],
    '/training/courses',
    { config: { params: { page: 0, size: 20 } } }
  );

  const enrollments = asArray<Enrollment>(enrollmentsQuery.data);
  const courses = coursesQuery.data?.items ?? [];
  const loading = enrollmentsQuery.isLoading || coursesQuery.isLoading;

  const eCols: ColumnsType<Enrollment> = [
    {
      title: t('pages.training.courseTitle'),
      dataIndex: 'courseId',
      render: (courseId: string) => courses.find((course) => course.id === courseId)?.title ?? '-'
    },
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
