import { Descriptions, Drawer, List, Spin, Tag } from "antd";
import ReactECharts from "echarts-for-react";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { apiClient } from "../../shared/api/client";

type EmployeeNode = { id: string; fullName: string; employeeNo: string; positionTitle?: string; manager?: boolean };
type TreeNode = { id: string; code: string; name: string; manager?: EmployeeNode | null; employees: EmployeeNode[] };

export default function OrgChart() {
  const { t } = useTranslation();
  const [tree, setTree] = useState<TreeNode[]>([]);
  const [loading, setLoading] = useState(false);
  const [selected, setSelected] = useState<TreeNode | null>(null);

  useEffect(() => {
    setLoading(true);
    apiClient.get<TreeNode[]>("/departments/tree")
      .then(r => setTree(r.data ?? []))
      .catch(() => setTree([]))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <Spin style={{ display: "block", margin: "40px auto" }} />;

  const departmentNodes = tree.map((dept) => {
    const manager = dept.manager ?? dept.employees?.find((employee) => employee.manager);
    return {
      name: dept.name,
      value: dept.code,
      departmentId: dept.id,
      employeeCount: dept.employees?.length ?? 0,
      managerName: manager?.fullName ?? "-",
      label: {
        formatter: `${dept.name}\n${manager?.fullName ?? t("pages.departments.noManager")} - ${dept.employees?.length ?? 0} ${t("common.employees").toLowerCase()}`
      }
    };
  });

  const chartOption = {
    tooltip: {
      trigger: "item",
      triggerOn: "mousemove",
      formatter: (params: any) => {
        if (!params.data?.departmentId) return params.name;
        return `<strong>${params.name}</strong><br/>${t("pages.departments.manager")}: ${params.data.managerName}<br/>${t("pages.departments.employeeCount")}: ${params.data.employeeCount}`;
      }
    },
    series: [{
      type: "tree",
      data: [{
        name: t("pages.departments.company"),
        children: departmentNodes
      }],
      left: "6%",
      right: "18%",
      top: "8%",
      bottom: "8%",
      symbol: "roundRect",
      symbolSize: [12, 8],
      orient: "LR",
      label: {
        position: "right",
        verticalAlign: "middle",
        lineHeight: 18,
        color: "#1f2937"
      },
      leaves: {
        label: {
          position: "right",
          verticalAlign: "middle",
          lineHeight: 18
        }
      },
      initialTreeDepth: 1,
      expandAndCollapse: true,
      animationDuration: 550
    }]
  };

  const handleEvents = {
    click: (params: any) => {
      const dept = tree.find(d => d.name === params.name);
      if (dept) setSelected(dept);
    }
  };

  return (
    <>
      <ReactECharts option={chartOption} style={{ height: Math.max(520, tree.length * 46) }} onEvents={handleEvents} />
      <Drawer title={selected ? t("pages.departments.drawerTitle", { name: selected.name }) : ""} width="min(480px, calc(100vw - 32px))"
        open={!!selected} onClose={() => setSelected(null)}>
        {selected && (
          <>
            <Descriptions bordered column={1} size="middle" style={{ marginBottom: 16 }}>
              <Descriptions.Item label={t("pages.departments.codeShort")}>{selected.code}</Descriptions.Item>
              <Descriptions.Item label={t("common.name")}>{selected.name}</Descriptions.Item>
              <Descriptions.Item label={t("pages.departments.manager")}>
                {selected.manager ? `${selected.manager.fullName} - ${selected.manager.employeeNo}` : "-"}
              </Descriptions.Item>
              <Descriptions.Item label={t("pages.departments.employeeCount")}>{selected.employees.length}</Descriptions.Item>
            </Descriptions>
            <h4>{t("common.employees")}</h4>
            <List dataSource={selected.employees} renderItem={e => (
              <List.Item>
                <div>
                  <strong>{e.fullName}</strong> - {e.employeeNo}
                  {e.manager ? <Tag color="blue" style={{ marginLeft: 8 }}>{t("pages.departments.manager")}</Tag> : null}
                  {e.positionTitle ? <div style={{ color: "#64748b", marginTop: 2 }}>{e.positionTitle}</div> : null}
                </div>
              </List.Item>
            )} />
          </>
        )}
      </Drawer>
    </>
  );
}
