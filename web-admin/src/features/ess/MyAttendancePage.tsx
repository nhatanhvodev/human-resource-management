import { Button, Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { apiClient } from '../../shared/api/client';
import type { PageResponse } from '../../shared/api/types';
import { getEmployeeId } from '../../shared/auth/jwt';
import { StatusTag } from '../../shared/ui/StatusTag';

const { Title } = Typography;

type TimeEntry = {
  id: string; date: string; clockIn: string;
  clockOut: string; totalMinutes: number; status: string;
};

export default function MyAttendancePage() {
  const { t } = useTranslation();
  const [data, setData] = useState<TimeEntry[]>([]);
  const [loading, setLoading] = useState(true);

  const load = async () => {
    setLoading(true);
    try {
      const empId = getEmployeeId();
      const res = await apiClient.get<PageResponse<TimeEntry>>('/self/time-entries', {
        params: { page: 0, size: 20 },
        headers: { 'X-Employee-Id': empId }
      });
      setData(res.data.items ?? []);
    } finally { setLoading(false); }
  };

  useEffect(() => { void load(); }, []);

  const clockIn = async () => {
    try {
      await apiClient.post('/self/time-entries/clock-in', null, {
        headers: { 'X-Employee-Id': getEmployeeId() }
      });
      await load();
    } catch { /* ignore */ }
  };

  const clockOut = async () => {
    try {
      await apiClient.post('/self/time-entries/clock-out', null, {
        headers: { 'X-Employee-Id': getEmployeeId() }
      });
      await load();
    } catch { /* ignore */ }
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
        <Button type="primary" onClick={clockIn}>{t('ess.clockIn')}</Button>
        <Button onClick={clockOut}>{t('ess.clockOut')}</Button>
      </div>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
