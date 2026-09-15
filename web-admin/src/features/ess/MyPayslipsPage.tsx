import { Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useTranslation } from 'react-i18next';
import { API } from '../../shared/api/endpoints';
import { asArray, useApiQuery } from '../../shared/api/query';

const { Title } = Typography;

type Payslip = {
  id: string; basicSalary: number; allowance: number;
  deduction: number; overtimePay: number; netPay: number; issuedAt: string;
};

export default function MyPayslipsPage() {
  const { t, i18n } = useTranslation();
  const { data, isLoading } = useApiQuery<Payslip[]>(['self', 'payslips'], API.SELF.PAYSLIPS);
  const rows = asArray<Payslip>(data);

  const cols: ColumnsType<Payslip> = [
    { title: t('ess.period'), dataIndex: 'issuedAt', render: (v: string) => v ? new Date(v).toLocaleDateString(i18n.language === 'en' ? 'en-US' : 'vi-VN', { month: '2-digit', year: 'numeric' }) : '-' },
    { title: t('ess.grossPay'), render: (_, row) => (Number(row.basicSalary ?? 0) + Number(row.allowance ?? 0) + Number(row.overtimePay ?? 0)).toLocaleString(i18n.language === 'en' ? 'en-US' : 'vi-VN') },
    { title: t('ess.netPay'), dataIndex: 'netPay', render: (v: number) => v?.toLocaleString(i18n.language === 'en' ? 'en-US' : 'vi-VN') },
    { title: t('pages.payroll.deduction'), dataIndex: 'deduction', render: (v: number) => v?.toLocaleString(i18n.language === 'en' ? 'en-US' : 'vi-VN') },
    { title: t('ess.createdAt'), dataIndex: 'issuedAt', render: (v: string) => v ? new Date(v).toLocaleDateString(i18n.language === 'en' ? 'en-US' : 'vi-VN') : '-' }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('ess.payslips')}</Title></div>
      <Table rowKey="id" loading={isLoading} dataSource={rows} columns={cols} />
    </div>
  );
}
