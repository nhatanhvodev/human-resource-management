import { Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';

const { Title } = Typography;

type Payslip = {
  id: string; periodName: string; grossPay: number;
  netPay: number; status: string; createdAt: string;
};

export default function MyPayslipsPage() {
  const { t, i18n } = useTranslation();
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
    { title: t('ess.period'), dataIndex: 'periodName' },
    { title: t('ess.grossPay'), dataIndex: 'grossPay', render: (v: number) => v?.toLocaleString(i18n.language === 'en' ? 'en-US' : 'vi-VN') },
    { title: t('ess.netPay'), dataIndex: 'netPay', render: (v: number) => v?.toLocaleString(i18n.language === 'en' ? 'en-US' : 'vi-VN') },
    { title: t('common.status'), dataIndex: 'status' },
    { title: t('ess.createdAt'), dataIndex: 'createdAt' }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('ess.payslips')}</Title></div>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
