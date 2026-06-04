import { Button, Table, Tag, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';

const { Title } = Typography;

type OnboardingTask = {
  id: string; title: string; description: string;
  status: string; completedAt: string | null;
};

export default function MyOnboardingPage() {
  const [data, setData] = useState<OnboardingTask[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const empId = getEmployeeId();
        const res = await apiClient.get<OnboardingTask[]>(`/onboarding/tasks/${empId}`, {
          headers: { 'X-Employee-Id': empId }
        });
        if (mounted) setData(Array.isArray(res.data) ? res.data : []);
      } finally { if (mounted) setLoading(false); }
    })();
    return () => { mounted = false; };
  }, []);

  const cols: ColumnsType<OnboardingTask> = [
    { title: 'Nhiệm vụ', dataIndex: 'title' },
    { title: 'Mô tả', dataIndex: 'description' },
    { title: 'Trạng thái', dataIndex: 'status',
      render: (s: string) => <Tag color={s === 'DONE' ? 'green' : s === 'IN_PROGRESS' ? 'blue' : 'default'}>{s}</Tag> },
    { title: 'Hoàn thành', dataIndex: 'completedAt' }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>Onboarding</Title></div>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
