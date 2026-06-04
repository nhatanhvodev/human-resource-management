import { Empty, Table, Typography } from "antd";
import type { TableProps } from "antd";

const { Text } = Typography;

const defaultEmptyText = (
  <Empty
    image={Empty.PRESENTED_IMAGE_SIMPLE}
    description={
      <div className="app-table__empty">
        <Text strong>Không có dữ liệu</Text>
        <Text type="secondary">Chưa có bản ghi phù hợp với bộ lọc hiện tại.</Text>
      </div>
    }
  />
);

export function AppTable<T extends object>(props: TableProps<T>) {
  return (
    <Table<T>
      bordered
      size="middle"
      {...props}
      className={["app-table", props.className].filter(Boolean).join(" ")}
      locale={{ emptyText: defaultEmptyText, ...props.locale }}
      scroll={{ x: "max-content", y: "calc(100vh - 480px)", ...props.scroll }}
    />
  );
}
