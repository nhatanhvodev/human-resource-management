import { Card, Descriptions, Skeleton, Typography } from 'antd';
import { UserOutlined } from '@ant-design/icons';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';

const { Title } = Typography;

type Profile = {
  id: string; fullName: string; employeeNo: string;
  departmentName?: string; positionTitle?: string;
  employmentStatus?: string;
};

export default function MyProfilePage() {
  const { t } = useTranslation();
  const [profile, setProfile] = useState<Profile | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const empId = getEmployeeId();
        const res = await apiClient.get<Profile>('/self/profile', {
          headers: { 'X-Employee-Id': empId }
        });
        if (mounted) setProfile(res.data);
      } catch { /* ignore */ }
      finally { if (mounted) setLoading(false); }
    })();
    return () => { mounted = false; };
  }, []);

  return (
    <div className="page-header">
      <Title level={3}><UserOutlined /> {t('ess.profile')}</Title>
      <Card>
        <Skeleton loading={loading} active>
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
