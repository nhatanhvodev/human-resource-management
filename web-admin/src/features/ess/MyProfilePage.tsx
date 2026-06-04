import { Card, Col, Descriptions, Row, Skeleton, Typography } from 'antd';
import { UserOutlined } from '@ant-design/icons';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { apiClient } from '../../shared/api/client';

const { Title } = Typography;

type Profile = {
  id: string; fullName: string; employeeNo: string;
  department?: { name: string }; position?: { title: string };
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
        const token = localStorage.getItem('token');
        if (!token) return;
        const payload = JSON.parse(atob(token.split('.')[1]));
        const res = await apiClient.get<Profile>(`/employees/${payload.sub}`, {
          headers: { 'X-Employee-Id': payload.sub }
        });
        if (mounted) setProfile(res.data);
      } catch { /* ignore */ }
      finally { if (mounted) setLoading(false); }
    })();
    return () => { mounted = false; };
  }, []);

  return (
    <div className="page-header">
      <Title level={3}><UserOutlined /> {t('nav.employees')}</Title>
      <Card>
        <Skeleton loading={loading} active>
          {profile ? (
            <Descriptions bordered column={2}>
              <Descriptions.Item label="Mã NV">{profile.employeeNo}</Descriptions.Item>
              <Descriptions.Item label="Họ tên">{profile.fullName}</Descriptions.Item>
              <Descriptions.Item label="Phòng ban">{profile.department?.name ?? '-'}</Descriptions.Item>
              <Descriptions.Item label="Vị trí">{profile.position?.title ?? '-'}</Descriptions.Item>
              <Descriptions.Item label="Trạng thái">{profile.employmentStatus ?? '-'}</Descriptions.Item>
            </Descriptions>
          ) : (
            <p>Không tải được thông tin hồ sơ.</p>
          )}
        </Skeleton>
      </Card>
    </div>
  );
}
