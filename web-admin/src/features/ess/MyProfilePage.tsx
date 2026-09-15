import { Card, Descriptions, Skeleton, Typography } from 'antd';
import { UserOutlined } from '@ant-design/icons';
import { useTranslation } from 'react-i18next';
import { API } from '../../shared/api/endpoints';
import { useApiQuery } from '../../shared/api/query';

const { Title } = Typography;

type Profile = {
  id: string; fullName: string; employeeNo: string;
  departmentName?: string; positionTitle?: string;
  employmentStatus?: string;
};

export default function MyProfilePage() {
  const { t } = useTranslation();
  // Identity comes from the JWT claim server-side; no employee header needed.
  const { data: profile, isLoading } = useApiQuery<Profile>(['self', 'profile'], API.SELF.PROFILE);

  return (
    <div className="page-header">
      <Title level={3}><UserOutlined /> {t('ess.profile')}</Title>
      <Card>
        <Skeleton loading={isLoading} active>
          {profile ? (
            <Descriptions bordered column={2}>
              <Descriptions.Item label={t('ess.employeeNoShort')}>{profile.employeeNo}</Descriptions.Item>
              <Descriptions.Item label={t('pages.employees.fullName')}>{profile.fullName}</Descriptions.Item>
              <Descriptions.Item label={t('common.department')}>{profile.departmentName ?? '-'}</Descriptions.Item>
              <Descriptions.Item label={t('common.position')}>{profile.positionTitle ?? '-'}</Descriptions.Item>
              <Descriptions.Item label={t('common.status')}>{profile.employmentStatus ?? '-'}</Descriptions.Item>
            </Descriptions>
          ) : (
            <p>{t('ess.profileLoadError')}</p>
          )}
        </Skeleton>
      </Card>
    </div>
  );
}
