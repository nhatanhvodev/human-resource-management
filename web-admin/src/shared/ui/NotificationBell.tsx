import { BellOutlined } from '@ant-design/icons';
import { Badge, Dropdown, List, Typography } from 'antd';
import { useEffect, useRef, useState } from 'react';
import { getEmployeeId } from '../auth/jwt';
import { apiClient } from '../api/client';

const { Text } = Typography;

type Notification = {
  id: string; title: string; body: string; type: string;
  isRead: boolean; createdAt: string;
};

export function NotificationBell() {
  const [notifs, setNotifs] = useState<Notification[]>([]);
  const [unread, setUnread] = useState(0);
  const pollRef = useRef<ReturnType<typeof setInterval>>();

  const load = async () => {
    try {
      const empId = getEmployeeId();
      const [dataRes, countRes] = await Promise.all([
        apiClient.get<Notification[]>('/notifications/mine?unreadOnly=false', {
          headers: { 'X-Employee-Id': empId }
        }),
        apiClient.get<{ unreadCount: number }>('/notifications/mine/count', {
          headers: { 'X-Employee-Id': empId }
        })
      ]);
      setNotifs(Array.isArray(dataRes.data) ? dataRes.data.slice(0, 10) : []);
      setUnread(countRes.data?.unreadCount ?? 0);
    } catch { /* ignore */ }
  };

  useEffect(() => {
    void load();
    pollRef.current = setInterval(load, 30000);
    return () => { if (pollRef.current) clearInterval(pollRef.current); };
  }, []);

  const items = notifs.length > 0 ? notifs.map(n => ({
    key: n.id,
    label: (
      <div style={{ maxWidth: 280 }}>
        <Text strong={!n.isRead}>{n.title}</Text>
        <br /><Text type="secondary" style={{ fontSize: 12 }}>{n.body}</Text>
      </div>
    )
  })) : [{ key: 'empty', label: <Text type="secondary">Không có thông báo</Text> }];

  return (
    <Dropdown menu={{ items }} trigger={['click']} placement="bottomRight">
      <Badge count={unread} size="small">
        <BellOutlined style={{ fontSize: 18, cursor: 'pointer', color: '#fff' }} />
      </Badge>
    </Dropdown>
  );
}
