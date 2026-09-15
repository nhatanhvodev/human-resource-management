import { Button, Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useTranslation } from 'react-i18next';
import { API } from '../../shared/api/endpoints';
import { useApiMutation, useApiQuery } from '../../shared/api/query';
import type { PageResponse } from '../../shared/api/types';
import { StatusTag } from '../../shared/ui/StatusTag';

const { Title } = Typography;

type LeaveItem = {
  id: string; leaveType: string; fromDate: string;
  toDate: string; reason: string; status: string;
};

export default function MyLeavePage() {
  const { t } = useTranslation();
  const { data, isLoading } = useApiQuery<PageResponse<LeaveItem>>(
    ['self', 'leave-requests'],
    API.SELF.LEAVE_REQUESTS,
    { config: { params: { page: 0, size: 20 } } }
  );

  const createLeave = useApiMutation<LeaveItem, { fromDate: string; toDate: string; leaveType: string; reason?: string }>({
    invalidateKeys: [['self', 'leave-requests'], ['self', 'leave-balances']],
  });

  const submitLeave = () => {
    // Minimal self-service submit; full form lives in the HR flow.
    void createLeave.mutateAsync({
      url: API.SELF.LEAVE_REQUESTS,
      body: { fromDate: new Date().toISOString().slice(0, 10), toDate: new Date().toISOString().slice(0, 10), leaveType: 'ANNUAL' },
    }).catch(() => undefined);
  };

  const cols: ColumnsType<LeaveItem> = [
    { title: t('common.type'), dataIndex: 'leaveType' },
    { title: t('common.fromDate'), dataIndex: 'fromDate' },
    { title: t('common.toDate'), dataIndex: 'toDate' },
    { title: t('common.reason'), dataIndex: 'reason' },
    { title: t('common.status'), dataIndex: 'status',
      render: (s: string) => <StatusTag value={s} /> }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('nav.leave')}</Title></div>
      <Button type="primary" style={{ marginBottom: 16 }} loading={createLeave.isPending} onClick={submitLeave}>
        {t('ess.submitLeave')}
      </Button>
      <Table rowKey="id" loading={isLoading} dataSource={data?.items ?? []} columns={cols} />
    </div>
  );
}
