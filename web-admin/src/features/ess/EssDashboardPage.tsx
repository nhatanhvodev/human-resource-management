import { Card, Col, Row, Statistic, Typography } from 'antd';
import { useTranslation } from 'react-i18next';

const { Title } = Typography;

export default function EssDashboardPage() {
  const { t } = useTranslation();

  return (
    <div>
      <div className="page-header"><Title level={3}>{t('nav.dashboard')}</Title></div>
      <Row gutter={[16, 16]}>
        <Col xs={24} sm={12} lg={8}>
          <Card><Statistic title={t('ess.workdaysThisMonth')} value={22} suffix="/ 26" /></Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card><Statistic title={t('ess.remainingLeave')} value={12} valueStyle={{ color: '#3f8600' }} /></Card>
        </Col>
        <Col xs={24} sm={12} lg={8}>
          <Card><Statistic title={t('ess.coursesInProgress')} value={2} /></Card>
        </Col>
      </Row>
    </div>
  );
}
