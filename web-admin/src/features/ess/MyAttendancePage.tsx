import { Button, Table, Tag, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';

const { Title } = Typography;

type TimeEntry = {
  id: string; date: string; clockIn: string;
  clockOut: string; totalMinutes: number; status: string;
};

export default function MyAttendancePage() {
  const [data, setData] = useState<TimeEntry[]>([]);
  const [loading, setLoading] = useState(true);

  const load = async () => {
    setLoading(true);
    try {
      const empId = getEmployeeId();
      const res = await apiClient.get<TimeEntry[]>('/time-entries/mine', {
        headers: { 'X-Employee-Id': empId }
      });
      setData(Array.isArray(res.data) ? res.data : []);
    } finally { setLoading(false); }
  };

  useEffect(() => { void load(); }, []);

  const clockIn = async () => {
    try {
      await apiClient.post('/time-entries/clock-in', null, {
        headers: { 'X-Employee-Id': getEmployeeId() }
      });
      await load();
    } catch { /* ignore */ }
  };

  const clockOut = async () => {
    try {
      await apiClient.post('/time-entries/clock-out', null, {
        headers: { 'X-Employee-Id': getEmployeeId() }
      });
      await load();
    } catch { /* ignore */ }
  };

  const cols: ColumnsType<TimeEntry> = [
    { title: 'Ngày', dataIndex: 'date' },
    { title: 'Vào', dataIndex: 'clockIn' },
    { title: 'Ra', dataIndex: 'clockOut' },
    { title: 'Phút', dataIndex: 'totalMinutes' },
    { title: 'Trạng thái', dataIndex: 'status',
      render: (s: string) => <Tag color={s === 'APPROVED' ? 'green' : 'gold'}>{s}</Tag> }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>Chấm công</Title></div>
      <div style={{ marginBottom: 16, display: 'flex', gap: 8 }}>
        <Button type="primary" onClick={clockIn}>Vào ca</Button>
        <Button onClick={clockOut}>Ra ca</Button>
      </div>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
