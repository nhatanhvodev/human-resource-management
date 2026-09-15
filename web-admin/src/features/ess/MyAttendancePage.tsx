import { Button, Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useTranslation } from 'react-i18next';
import { API } from '../../shared/api/endpoints';
import { useApiMutation, useApiQuery } from '../../shared/api/query';
import type { PageResponse } from '../../shared/api/types';
import { StatusTag } from '../../shared/ui/StatusTag';

const { Title } = Typography;

type TimeEntry = {
  id: string; date: string; clockIn: string;
  clockOut: string; totalMinutes: number; status: string;
};

export default function MyAttendancePage() {
  const { t } = useTranslation();
  const { data, isLoading } = useApiQuery<PageResponse<TimeEntry>>(
    ['self', 'time-entries'],
    API.SELF.TIME_ENTRIES,
    { config: { params: { page: 0, size: 20 } } }
  );

  const clockMutation = useApiMutation<TimeEntry>({
    invalidateKeys: [['self', 'time-entries']],
  });

  const clockIn = () => {
    void clockMutation.mutateAsync({ url: API.SELF.CLOCK_IN, body: null }).catch(() => undefined);
  };

  const clockOut = () => {
    void clockMutation.mutateAsync({ url: API.SELF.CLOCK_OUT, body: null }).catch(() => undefined);
  };

  const cols: ColumnsType<TimeEntry> = [
    { title: t('common.date'), dataIndex: 'date' },
    { title: t('pages.attendance.clockIn'), dataIndex: 'clockIn' },
    { title: t('pages.attendance.clockOut'), dataIndex: 'clockOut' },
    { title: t('pages.attendance.minutes'), dataIndex: 'totalMinutes' },
    { title: t('common.status'), dataIndex: 'status',
      render: (s: string) => <StatusTag value={s} /> }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('nav.attendance')}</Title></div>
      <div style={{ marginBottom: 16, display: 'flex', gap: 8 }}>
        <Button type="primary" onClick={clockIn} loading={clockMutation.isPending}>{t('ess.clockIn')}</Button>
        <Button onClick={clockOut} loading={clockMutation.isPending}>{t('ess.clockOut')}</Button>
      </div>
      <Table rowKey="id" loading={isLoading} dataSource={data?.items ?? []} columns={cols} />
    </div>
  );
}
