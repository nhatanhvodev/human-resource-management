import { Empty, Table, Typography } from "antd";
import type { TableProps } from "antd";
import { useTranslation } from "react-i18next";

const { Text } = Typography;

const defaultPagination = {
  pageSize: 20,
  showSizeChanger: true,
  pageSizeOptions: ["20", "50", "100"]
};

export function AppTable<T extends object>(props: TableProps<T>) {
  const { t } = useTranslation();
  const pagination =
    props.pagination === false
      ? false
      : {
          ...defaultPagination,
          ...(typeof props.pagination === "object" ? props.pagination : {})
        };

  const defaultEmptyText = (
    <Empty
      image={Empty.PRESENTED_IMAGE_SIMPLE}
      description={
        <div className="app-table__empty">
          <Text strong>{t("table.emptyTitle")}</Text>
          <Text type="secondary">{t("table.emptyDescription")}</Text>
        </div>
      }
    />
  );

  return (
    <Table<T>
      bordered
      size="middle"
      {...props}
      className={["app-table", props.className].filter(Boolean).join(" ")}
      locale={{ emptyText: defaultEmptyText, ...props.locale }}
      pagination={pagination}
      scroll={{ x: "max-content", y: "calc(100vh - 400px)", ...props.scroll }}
    />
  );
}
