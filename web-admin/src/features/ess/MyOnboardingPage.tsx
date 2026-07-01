import { Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';
import { StatusTag } from '../../shared/ui/StatusTag';

const { Title } = Typography;

type OnboardingTask = {
  id: string; title: string; description: string;
  status: string; completedAt: string | null;
};

export default function MyOnboardingPage() {
  const { t } = useTranslation();
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
    { title: t('ess.task'), dataIndex: 'title' },
    { title: t('common.description'), dataIndex: 'description' },
    { title: t('common.status'), dataIndex: 'status',
      render: (s: string) => <StatusTag value={s} /> },
    { title: t('ess.completedAt'), dataIndex: 'completedAt' }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('nav.onboarding')}</Title></div>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
