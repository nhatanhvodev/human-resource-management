import { BellOutlined, DownloadOutlined, LeftOutlined } from '@ant-design/icons';
import { Badge, Button, Drawer, List, Space, Typography } from 'antd';
import { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { getEmployeeId } from '../auth/jwt';
import { apiClient } from '../api/client';

const { Text, Title, Paragraph } = Typography;

type Notification = {
  id: string;
  title: string;
  body: string;
  detail?: string;
  type: string;
  isRead: boolean;
  createdAt: string;
  creatorName?: string;
  fileUrl?: string;
  fileName?: string;
};

const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export function NotificationBell() {
  const { t } = useTranslation();
  const [notifs, setNotifs] = useState<Notification[]>([]);
  const [unread, setUnread] = useState(0);
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [selectedNotif, setSelectedNotif] = useState<Notification | null>(null);
  const pollRef = useRef<ReturnType<typeof setInterval>>();

  const load = async () => {
    try {
      const empId = getEmployeeId();
      if (!uuidPattern.test(empId)) {
        setNotifs([]);
        setUnread(0);
        return;
      }
      const [dataRes, countRes] = await Promise.all([
        apiClient.get<Notification[] | { items: Notification[] }>('/notifications/mine?unreadOnly=false', {
          headers: { 'X-Employee-Id': empId }
        }),
        apiClient.get<{ unreadCount: number }>('/notifications/mine/count', {
          headers: { 'X-Employee-Id': empId }
        })
      ]);
      const data = Array.isArray(dataRes.data) ? dataRes.data : (dataRes.data?.items ?? []);
      setNotifs(data.slice(0, 20));
      setUnread(countRes.data?.unreadCount ?? 0);
    } catch { /* ignore */ }
  };

  useEffect(() => {
    void load();
    pollRef.current = setInterval(load, 30000);
    return () => { if (pollRef.current) clearInterval(pollRef.current); };
  }, []);

  const openDrawer = () => {
    setSelectedNotif(null);
    setDrawerOpen(true);
  };

  const closeDrawer = () => {
    setDrawerOpen(false);
    setSelectedNotif(null);
  };

  const selectNotif = (notif: Notification) => {
    setSelectedNotif(notif);
  };

  const backToList = () => {
    setSelectedNotif(null);
  };

  return (
    <>
      <Badge count={unread} size="small">
        <BellOutlined
          style={{ fontSize: 18, cursor: 'pointer', color: '#fff' }}
          onClick={openDrawer}
        />
      </Badge>

      <Drawer
        title={
          selectedNotif
            ? (
              <Space>
                <Button type="text" icon={<LeftOutlined />} onClick={backToList} />
                <span>{t('notification.detail') || 'Notification Detail'}</span>
              </Space>
            )
            : (t('nav.announcements') || 'Notifications')
        }
        placement="right"
        width={420}
        open={drawerOpen}
        onClose={closeDrawer}
      >
        {selectedNotif ? (
          <div style={{ padding: '0 8px' }}>
            <Title level={4} style={{ marginTop: 0 }}>{selectedNotif.title}</Title>
            <Paragraph>
              <Text strong>{selectedNotif.body}</Text>
            </Paragraph>
            {selectedNotif.detail && (
              <Paragraph style={{ whiteSpace: 'pre-wrap' }}>
                {selectedNotif.detail}
              </Paragraph>
            )}
            {selectedNotif.creatorName && (
              <Paragraph type="secondary">
                {t('notification.creator') || 'From'}: {selectedNotif.creatorName}
              </Paragraph>
            )}
            {selectedNotif.createdAt && (
              <Paragraph type="secondary">
                {new Date(selectedNotif.createdAt).toLocaleString()}
              </Paragraph>
            )}
            {selectedNotif.fileUrl && selectedNotif.fileName && (
              <Paragraph>
                <a
                  href={selectedNotif.fileUrl}
                  download={selectedNotif.fileName}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <Space>
                    <DownloadOutlined />
                    <span>{selectedNotif.fileName}</span>
                  </Space>
                </a>
              </Paragraph>
            )}
          </div>
        ) : notifs.length > 0 ? (
          <List
            dataSource={notifs}
            renderItem={(item) => (
              <List.Item
                key={item.id}
                style={{ cursor: 'pointer' }}
                onClick={() => selectNotif(item)}
              >
                <List.Item.Meta
                  title={
                    <Text strong={!item.isRead} style={{ fontSize: 14 }}>
                      {item.title}
                    </Text>
                  }
                  description={
                    <Text type="secondary" style={{ fontSize: 12 }} ellipsis>
                      {item.body}
                    </Text>
                  }
                />
              </List.Item>
            )}
          />
        ) : (
          <div style={{ textAlign: 'center', padding: 40 }}>
            <Text type="secondary">{t('notification.empty') || 'No notifications'}</Text>
          </div>
        )}
      </Drawer>
    </>
  );
}
