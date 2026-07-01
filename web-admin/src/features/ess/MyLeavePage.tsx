import { Button, Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { apiClient } from '../../shared/api/client';
import type { PageResponse } from '../../shared/api/types';
import { getEmployeeId } from '../../shared/auth/jwt';
import { StatusTag } from '../../shared/ui/StatusTag';

const { Title } = Typography;

type LeaveItem = {
  id: string; leaveType: string; fromDate: string;
  toDate: string; reason: string; status: string;
};

export default function MyLeavePage() {
  const { t } = useTranslation();
  const [data, setData] = useState<LeaveItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const empId = getEmployeeId();
        const res = await apiClient.get<PageResponse<LeaveItem>>('/self/leave-requests', {
          params: { page: 0, size: 20 },
          headers: { 'X-Employee-Id': empId }
        });
        if (mounted) setData(res.data.items ?? []);
      } finally { if (mounted) setLoading(false); }
    })();
    return () => { mounted = false; };
  }, []);

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
      <Button type="primary" style={{ marginBottom: 16 }}>{t('ess.submitLeave')}</Button>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
