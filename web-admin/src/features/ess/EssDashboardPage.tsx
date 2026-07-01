import { Card, Col, Row, Statistic, Typography } from 'antd';
import { useCallback, useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { apiClient } from '../../shared/api/client';

const { Title } = Typography;

export default function EssDashboardPage() {
  const { t } = useTranslation();
  const [workdays, setWorkdays] = useState<number | null>(null);
  const [remainingLeave, setRemainingLeave] = useState<number | null>(null);
  const [coursesInProgress, setCoursesInProgress] = useState<number | null>(null);
  const [loading, setLoading] = useState(true);

  const loadDashboard = useCallback(async () => {
    setLoading(true);
    try {
      // Get today's time entry for work status
      const timeRes = await apiClient.get('/self/time-entries/today', {
        headers: { 'X-Employee-Id': 'self' }
      }).catch(() => null);

      // Get leave balances
      const leaveRes = await apiClient.get('/self/leave-balances', {
        headers: { 'X-Employee-Id': 'self' }
      }).catch(() => null);

      // Get training enrollments
      const enrollRes = await apiClient.get('/training/enrollments/employee/self', {
        headers: { 'X-Employee-Id': 'self' }
      }).catch(() => null);

      // Parse workdays from time entry
      if (timeRes?.data) {
        const data = timeRes.data as any;
        setWorkdays(data.workdaysThisMonth ?? data.workedDays ?? null);
      }

      // Parse remaining leave from balances
      if (leaveRes?.data) {
        const balances = Array.isArray(leaveRes.data) ? leaveRes.data : [];
        const totalRemaining = balances.reduce(
          (sum: number, b: any) => sum + ((b.totalDays ?? 0) - (b.usedDays ?? 0) - (b.pendingDays ?? 0)),
          0
        );
        setRemainingLeave(totalRemaining);
      }

      // Count in-progress courses
      if (enrollRes?.data) {
        const enrollments = Array.isArray(enrollRes.data) ? enrollRes.data : [];
        const inProgress = enrollments.filter((e: any) => e.status === 'IN_PROGRESS').length;
        setCoursesInProgress(inProgress);
      }
    } catch {
      // Silently fail - dashboard shows fallback values
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void loadDashboard();
  }, [loadDashboard]);

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('nav.dashboard')}</Title></div>
      <Row gutter={[16, 16]}>
        <Col xs={24} sm={12} lg={8}>
          <Card loading={loading}>
            <Statistic title={t('ess.workdaysThisMonth')} value={workdays ?? '—'} suffix="/ 26" />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card loading={loading}>
            <Statistic
              title={t('ess.remainingLeave')}
              value={remainingLeave ?? '—'}
              valueStyle={{ color: '#3f8600' }}
            />
          </Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card loading={loading}>
            <Statistic title={t('ess.coursesInProgress')} value={coursesInProgress ?? '—'} />
          </Card>
        </Col>
      </Row>
    </div>
  );
}
