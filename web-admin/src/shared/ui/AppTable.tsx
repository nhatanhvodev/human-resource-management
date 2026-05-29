import { Table } from "antd";
import type { TableProps } from "antd";

export function AppTable<T extends object>(props: TableProps<T>) {
  return <Table<T> bordered size="middle" scroll={{ x: "max-content", ...props.scroll }} {...props} />;
}
