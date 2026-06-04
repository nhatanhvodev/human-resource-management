import { Button, Table, Tag, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';

const { Title } = Typography;

type LeaveItem = {
  id: string; leaveType: string; fromDate: string;
  toDate: string; reason: string; status: string;
};

export default function MyLeavePage() {
  const [data, setData] = useState<LeaveItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const empId = getEmployeeId();
        const res = await apiClient.get<LeaveItem[]>('/leave/mine', {
          headers: { 'X-Employee-Id': empId }
        });
        if (mounted) setData(Array.isArray(res.data) ? res.data : []);
      } finally { if (mounted) setLoading(false); }
    })();
    return () => { mounted = false; };
  }, []);

  const cols: ColumnsType<LeaveItem> = [
    { title: 'Loại', dataIndex: 'leaveType' },
    { title: 'Từ ngày', dataIndex: 'fromDate' },
    { title: 'Đến ngày', dataIndex: 'toDate' },
    { title: 'Lý do', dataIndex: 'reason' },
    { title: 'Trạng thái', dataIndex: 'status',
      render: (s: string) => <Tag color={s === 'APPROVED' ? 'green' : s === 'PENDING' ? 'gold' : 'red'}>{s}</Tag> }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>Nghỉ phép</Title></div>
      <Button type="primary" style={{ marginBottom: 16 }}>Gửi đơn nghỉ phép</Button>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
