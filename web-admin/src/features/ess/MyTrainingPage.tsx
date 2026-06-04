import { Card, Col, Progress, Row, Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';

const { Title } = Typography;

type Enrollment = {
  id: string; courseId: string; progress: number; status: string;
};

type Course = {
  id: string; title: string; description: string;
  category: string; instructorName: string;
};

export default function MyTrainingPage() {
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
    { title: 'Khóa học ID', dataIndex: 'courseId' },
    { title: 'Tiến độ', dataIndex: 'progress', render: (v: number) => <Progress percent={v} size="small" /> },
    { title: 'Trạng thái', dataIndex: 'status' }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>Đào tạo</Title></div>
      <Row gutter={[16, 16]}>
        {courses.map(c => (
          <Col xs={24} sm={12} lg={8} key={c.id}>
            <Card title={c.title} loading={loading}>
              <p>{c.description}</p>
              <p>Giảng viên: {c.instructorName}</p>
              <p>Danh mục: {c.category}</p>
            </Card>
          </Col>
        ))}
      </Row>
      <Title level={4} style={{ marginTop: 24 }}>Khóa học của tôi</Title>
      <Table rowKey="id" loading={loading} dataSource={enrollments} columns={eCols} />
    </div>
  );
}
