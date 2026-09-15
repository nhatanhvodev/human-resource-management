import { Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useTranslation } from 'react-i18next';
import { asArray, useApiQuery } from '../../shared/api/query';
import { useAccess } from '../../shared/auth/access';
import { StatusTag } from '../../shared/ui/StatusTag';

const { Title } = Typography;

type OnboardingTask = {
  id: string; title: string; description: string;
  status: string; completedAt: string | null;
};

export default function MyOnboardingPage() {
  const { t } = useTranslation();
  // Path param needs a concrete id: use DB-truth from /authz/me, not the token.
  const { access } = useAccess();
  const empId = access?.employeeId ?? '';
  const { data, isLoading } = useApiQuery<OnboardingTask[]>(
    ['self', 'onboarding-tasks', empId],
    `/onboarding/tasks/${empId}`,
    { enabled: Boolean(empId) }
  );

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
      <Table rowKey="id" loading={isLoading} dataSource={asArray<OnboardingTask>(data)} columns={cols} />
    </div>
  );
}
