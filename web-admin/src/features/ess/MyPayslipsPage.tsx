import { Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';

const { Title } = Typography;

type Payslip = {
  id: string; periodName: string; grossPay: number;
  netPay: number; status: string; createdAt: string;
};

export default function MyPayslipsPage() {
  const [data, setData] = useState<Payslip[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const empId = getEmployeeId();
        const res = await apiClient.get<Payslip[]>('/payslips/mine', {
          headers: { 'X-Employee-Id': empId }
        });
        if (mounted) setData(Array.isArray(res.data) ? res.data : []);
      } finally { if (mounted) setLoading(false); }
    })();
    return () => { mounted = false; };
  }, []);

  const cols: ColumnsType<Payslip> = [
    { title: 'Kỳ lương', dataIndex: 'periodName' },
    { title: 'Tổng thu nhập', dataIndex: 'grossPay', render: (v: number) => v?.toLocaleString() },
    { title: 'Thực nhận', dataIndex: 'netPay', render: (v: number) => v?.toLocaleString() },
    { title: 'Trạng thái', dataIndex: 'status' },
    { title: 'Ngày tạo', dataIndex: 'createdAt' }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>Phiếu lương</Title></div>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
