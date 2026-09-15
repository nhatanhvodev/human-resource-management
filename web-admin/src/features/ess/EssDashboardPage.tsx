import { Card, Col, Row, Statistic, Typography } from 'antd';
import { useTranslation } from 'react-i18next';

import { API } from '../../shared/api/endpoints';
import { asArray, useApiQuery } from '../../shared/api/query';
import type { PageResponse } from '../../shared/api/types';
import { useAccess } from '../../shared/auth/access';

const { Title } = Typography;

type LeaveBalance = { leaveType: string; totalDays: number; usedDays: number; pendingDays: number };
type TimeEntry = { id: string; date: string; totalMinutes: number };
type Enrollment = { id: string; status: string };

export default function EssDashboardPage() {
  const { t } = useTranslation();
  const { access } = useAccess();
  const empId = access?.employeeId ?? '';

  const leaveQuery = useApiQuery<LeaveBalance[]>(['self', 'leave-balances'], API.SELF.LEAVE_BALANCES);
  const timeQuery = useApiQuery<PageResponse<TimeEntry>>(
    ['self', 'time-entries', 'recent'],
    API.SELF.TIME_ENTRIES,
    { config: { params: { page: 0, size: 100 } } }
  );
  const enrollQuery = useApiQuery<Enrollment[]>(
    ['self', 'enrollments', empId],
    `/training/enrollments/employee/${empId}`,
    { enabled: Boolean(empId) }
  );

  const loading = leaveQuery.isLoading || timeQuery.isLoading || enrollQuery.isLoading;

  const balances = asArray<LeaveBalance>(leaveQuery.data);
  const remainingLeave = balances.reduce(
    (sum, b) => sum + (Number(b.totalDays ?? 0) - Number(b.usedDays ?? 0) - Number(b.pendingDays ?? 0)),
    0
  );

  const monthPrefix = new Date().toISOString().slice(0, 7);
  const workdays = (timeQuery.data?.items ?? []).filter((e) => e.date?.startsWith(monthPrefix)).length;

  const enrollments = asArray<Enrollment>(enrollQuery.data);
  const coursesInProgress = enrollments.filter((e) => e.status === 'IN_PROGRESS').length;

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('nav.dashboard')}</Title></div>
      <Row gutter={[16, 16]}>
        <Col xs={24} sm={12} lg={8}>
          <Card loading={loading}>
            <Statistic title={t('ess.workdaysThisMonth')} value={workdays} suffix="/ 26" />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card loading={loading}>
            <Statistic
              title={t('ess.remainingLeave')}
              value={remainingLeave}
              valueStyle={{ color: '#3f8600' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card loading={loading}>
            <Statistic title={t('ess.coursesInProgress')} value={coursesInProgress} />
          </Card>
        </Col>
      </Row>
    </div>
  );
}
