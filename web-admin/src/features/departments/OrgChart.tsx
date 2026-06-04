import { Descriptions, Drawer, List, Spin } from "antd";
import ReactECharts from "echarts-for-react";
import { useEffect, useState } from "react";
import { apiClient } from "../../shared/api/client";

type EmployeeNode = { id: string; fullName: string; employeeNo: string };
type TreeNode = { id: string; code: string; name: string; employees: EmployeeNode[] };

export default function OrgChart() {
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

  const chartOption = {
    tooltip: { trigger: "item", triggerOn: "mousemove" },
    series: [{
      type: "tree",
      data: [{
        name: "Công ty",
        children: tree.map(dept => ({
          name: dept.name,
          value: dept.code,
          children: dept.employees?.map(emp => ({ name: emp.fullName, value: emp.employeeNo })) ?? []
        }))
      }],
      left: "2%",
      right: "2%",
      top: "10%",
      bottom: "10%",
      symbol: "roundRect",
      symbolSize: 8,
      orient: "LR",
      label: { position: "right", verticalAlign: "middle" },
      leaves: { label: { position: "left", verticalAlign: "middle" } },
      initialTreeDepth: 2,
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
      <ReactECharts option={chartOption} style={{ height: 500 }} onEvents={handleEvents} />
      <Drawer title={selected ? `Phòng ban: ${selected.name}` : ""} width="min(480px, calc(100vw - 32px))"
        open={!!selected} onClose={() => setSelected(null)}>
        {selected && (
          <>
            <Descriptions bordered column={1} size="middle" style={{ marginBottom: 16 }}>
              <Descriptions.Item label="Mã">{selected.code}</Descriptions.Item>
              <Descriptions.Item label="Tên">{selected.name}</Descriptions.Item>
              <Descriptions.Item label="Số nhân viên">{selected.employees.length}</Descriptions.Item>
            </Descriptions>
            <h4>Nhân viên</h4>
            <List dataSource={selected.employees} renderItem={e => (
              <List.Item><strong>{e.fullName}</strong> — {e.employeeNo}</List.Item>
            )} />
          </>
        )}
      </Drawer>
    </>
  );
}
