import { Button, Table, Typography } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';
import { apiClient } from '../../shared/api/client';
import { getEmployeeId } from '../../shared/auth/jwt';

const { Title } = Typography;

type DocumentItem = {
  id: string; originalName: string; fileType: string;
  fileSize: number; category: string; uploadedAt: string;
};

export default function MyDocumentsPage() {
  const [data, setData] = useState<DocumentItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let mounted = true;
    (async () => {
      try {
        const empId = getEmployeeId();
        const res = await apiClient.get<DocumentItem[]>('/documents/mine', {
          headers: { 'X-Employee-Id': empId }
        });
        if (mounted) setData(Array.isArray(res.data) ? res.data : []);
      } finally { if (mounted) setLoading(false); }
    })();
    return () => { mounted = false; };
  }, []);

  const cols: ColumnsType<DocumentItem> = [
    { title: 'Tên file', dataIndex: 'originalName' },
    { title: 'Loại', dataIndex: 'fileType' },
    { title: 'Kích thước', dataIndex: 'fileSize', render: (v: number) => `${(v / 1024).toFixed(1)} KB` },
    { title: 'Danh mục', dataIndex: 'category' },
    { title: 'Ngày tải lên', dataIndex: 'uploadedAt' }
  ];

  return (
    <div>
      <div className="page-header"><Title level={3}>Tài liệu</Title></div>
      <Button type="primary" style={{ marginBottom: 16 }}>Tải lên</Button>
      <Table rowKey="id" loading={loading} dataSource={data} columns={cols} />
    </div>
  );
}
