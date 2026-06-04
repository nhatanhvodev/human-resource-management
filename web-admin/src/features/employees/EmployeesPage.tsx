import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Descriptions, Drawer, Form, Input, Segmented, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import type { TablePaginationConfig } from "antd/es/table";
import { useCallback, useEffect, useMemo, useState } from "react";

import { apiClient } from "../../shared/api/client";
import type { PageResponse } from "../../shared/api/types";
import { AppTable } from "../../shared/ui/AppTable";
import { FormDrawer } from "../../shared/ui/FormDrawer";
import { PageToolbar } from "../../shared/ui/PageToolbar";
import { StatusTag } from "../../shared/ui/StatusTag";

type Employee = {
  id: string;
  employeeNo: string;
  fullName: string;
  departmentId: string;
  employmentStatus: string;
  hireDate: string;
  email?: string;
  phone?: string;
  positionId?: string;
  positionTitle?: string;
  dateOfBirth?: string;
  gender?: string;
  nationalId?: string;
  address?: string;
  bankAccount?: string;
  taxCode?: string;
};

type Department = {
  id: string;
  code: string;
  name: string;
};

type Position = {
  id: string;
  code: string;
  title: string;
  departmentId: string;
};

type EmployeeContract = {
  id: string;
  contractType: string;
  startDate: string;
  endDate?: string;
  salary: number;
};

type EmployeeSkill = {
  id: string;
  skillName: string;
  proficiencyLevel: string;
};

type EmergencyContact = {
  id: string;
  fullName: string;
  relationship: string;
  phone: string;
};

const emptyPage: PageResponse<Employee> = {
  items: [],
  page: 0,
  size: 10,
  totalItems: 0,
  totalPages: 0
};

export default function EmployeesPage() {
  const [status, setStatus] = useState<string>("ALL");
  const [page, setPage] = useState(0);
  const [data, setData] = useState<PageResponse<Employee>>(emptyPage);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [positions, setPositions] = useState<Position[]>([]);
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [openCreate, setOpenCreate] = useState(false);
  const [detailEmployee, setDetailEmployee] = useState<Employee | null>(null);
  const [editingEmployee, setEditingEmployee] = useState<Employee | null>(null);
  const [detailContracts, setDetailContracts] = useState<EmployeeContract[]>([]);
  const [detailSkills, setDetailSkills] = useState<EmployeeSkill[]>([]);
  const [detailEmergencyContacts, setDetailEmergencyContacts] = useState<EmergencyContact[]>([]);
  const [detailLoading, setDetailLoading] = useState(false);
  const [form] = Form.useForm<{
    employeeNo: string;
    fullName: string;
    departmentId: string;
    hireDate: string;
    email?: string;
    phone?: string;
    dateOfBirth?: string;
    gender?: string;
    nationalId?: string;
    address?: string;
    bankAccount?: string;
    taxCode?: string;
    positionId?: string;
  }>();

  const loadEmployees = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await apiClient.get<PageResponse<Employee>>("/employees", {
        params: { page, size: 10, status: status === "ALL" ? undefined : status }
      });
      setData({ ...emptyPage, ...response.data, items: response.data.items ?? [] });
    } catch {
      setData(emptyPage);
      setError("Không tải được danh sách nhân viên");
    } finally {
      setLoading(false);
    }
  }, [page, status]);

  const loadDepartments = useCallback(async () => {
    try {
      const response = await apiClient.get<PageResponse<Department>>("/departments", {
        params: { page: 0, size: 100 }
      });
      setDepartments(response.data.items ?? []);
    } catch {
      setDepartments([]);
    }
  }, []);

  const loadPositions = useCallback(async () => {
    try {
      const response = await apiClient.get<PageResponse<Position>>("/positions", {
        params: { page: 0, size: 500 }
      });
      setPositions(response.data.items ?? []);
    } catch {
      setPositions([]);
    }
  }, []);

  const loadEmployeeDetail = useCallback(async (id: string) => {
    setDetailLoading(true);
    try {
      const [contractsRes, skillsRes, contactsRes] = await Promise.allSettled([
        apiClient.get<PageResponse<EmployeeContract>>(`/employees/${id}/contracts`, { params: { page: 0, size: 50 } }),
        apiClient.get<PageResponse<EmployeeSkill>>(`/employees/${id}/skills`, { params: { page: 0, size: 50 } }),
        apiClient.get<PageResponse<EmergencyContact>>(`/employees/${id}/emergency-contacts`, { params: { page: 0, size: 50 } })
      ]);
      setDetailContracts(contractsRes.status === "fulfilled" ? (contractsRes.value.data.items ?? []) : []);
      setDetailSkills(skillsRes.status === "fulfilled" ? (skillsRes.value.data.items ?? []) : []);
      setDetailEmergencyContacts(contactsRes.status === "fulfilled" ? (contactsRes.value.data.items ?? []) : []);
    } catch {
      setDetailContracts([]);
      setDetailSkills([]);
      setDetailEmergencyContacts([]);
    } finally {
      setDetailLoading(false);
    }
  }, []);

  useEffect(() => {
    void loadEmployees();
  }, [loadEmployees]);

  useEffect(() => {
    void loadDepartments();
  }, [loadDepartments]);

  useEffect(() => {
    void loadPositions();
  }, [loadPositions]);

  useEffect(() => {
    if (detailEmployee) {
      void loadEmployeeDetail(detailEmployee.id);
    } else {
      setDetailContracts([]);
      setDetailSkills([]);
      setDetailEmergencyContacts([]);
    }
  }, [detailEmployee, loadEmployeeDetail]);

  const departmentById = useMemo(() => new Map(departments.map((department) => [department.id, department])), [departments]);

  const submitEmployee = async (values: {
    employeeNo: string;
    fullName: string;
    departmentId: string;
    hireDate: string;
    email?: string;
    phone?: string;
    dateOfBirth?: string;
    gender?: string;
    nationalId?: string;
    address?: string;
    bankAccount?: string;
    taxCode?: string;
    positionId?: string;
  }) => {
    setSaving(true);
    setError(null);
    try {
      const profilePayload = {
        fullName: values.fullName.trim(),
        departmentId: values.departmentId,
        hireDate: values.hireDate,
        ...(values.email?.trim() ? { email: values.email.trim() } : {}),
        ...(values.phone?.trim() ? { phone: values.phone.trim() } : {}),
        ...(values.dateOfBirth ? { dateOfBirth: values.dateOfBirth } : {}),
        ...(values.gender ? { gender: values.gender } : {}),
        ...(values.nationalId?.trim() ? { nationalId: values.nationalId.trim() } : {}),
        ...(values.address?.trim() ? { address: values.address.trim() } : {}),
        ...(values.bankAccount?.trim() ? { bankAccount: values.bankAccount.trim() } : {}),
        ...(values.taxCode?.trim() ? { taxCode: values.taxCode.trim() } : {}),
        ...(values.positionId ? { positionId: values.positionId } : {})
      };
      if (editingEmployee) {
        await apiClient.put(`/employees/${editingEmployee.id}/profile`, profilePayload);
      } else {
        await apiClient.post("/employees", {
          employeeNo: values.employeeNo?.trim(),
          fullName: profilePayload.fullName,
          departmentId: profilePayload.departmentId,
          hireDate: profilePayload.hireDate
        });
      }
      form.resetFields();
      setOpenCreate(false);
      setEditingEmployee(null);
      await loadEmployees();
    } catch {
      setError(
        editingEmployee
          ? "Không cập nhật được nhân viên. Kiểm tra họ tên, phòng ban và ngày vào làm."
          : "Không tạo được nhân viên. Kiểm tra mã nhân viên, phòng ban và dữ liệu bắt buộc."
      );
    } finally {
      setSaving(false);
    }
  };

  const openEdit = (employee: Employee) => {
    setEditingEmployee(employee);
    form.setFieldsValue({
      employeeNo: employee.employeeNo,
      fullName: employee.fullName,
      departmentId: employee.departmentId,
      hireDate: employee.hireDate,
      email: employee.email,
      phone: employee.phone,
      dateOfBirth: employee.dateOfBirth,
      gender: employee.gender,
      nationalId: employee.nationalId,
      address: employee.address,
      bankAccount: employee.bankAccount,
      taxCode: employee.taxCode,
      positionId: employee.positionId
    });
    setOpenCreate(true);
  };

  const closeDrawer = () => {
    form.resetFields();
    setEditingEmployee(null);
    setOpenCreate(false);
  };

  const changeEmployeeStatus = async (employee: Employee) => {
    const nextStatus = employee.employmentStatus === "ACTIVE" ? "INACTIVE" : "ACTIVE";
    setSaving(true);
    setError(null);
    try {
      await apiClient.patch(`/employees/${employee.id}/status`, { employmentStatus: nextStatus });
      await loadEmployees();
    } catch {
      setError("Không đổi được trạng thái nhân viên. Kiểm tra quyền cập nhật hoặc trạng thái hiện tại.");
    } finally {
      setSaving(false);
    }
  };

  const columns = useMemo<ColumnsType<Employee>>(
    () => [
      { title: "Mã nhân viên", dataIndex: "employeeNo", width: 160 },
      { title: "Họ và tên", dataIndex: "fullName" },
      { title: "Email", dataIndex: "email", width: 200, ellipsis: true },
      { title: "Số điện thoại", dataIndex: "phone", width: 130 },
      { title: "Vị trí", dataIndex: "positionTitle", width: 160 },
      {
        title: "Phòng ban",
        dataIndex: "departmentId",
        width: 220,
        render: (value: string) => {
          const department = departmentById.get(value);
          return department ? `${department.code} - ${department.name}` : value;
        }
      },
      { title: "Ngày vào làm", dataIndex: "hireDate", width: 140 },
      {
        title: "Trạng thái",
        dataIndex: "employmentStatus",
        width: 160,
        render: (value: string) => <StatusTag value={value} />
      },
      {
        title: "Thao tác",
        key: "actions",
        width: 300,
        render: (_, row) => (
          <Space>
            <Button size="small" onClick={() => openEdit(row)}>
              Sửa
            </Button>
            <Button size="small" onClick={() => setDetailEmployee(row)}>
              Chi tiết
            </Button>
            <Button size="small" disabled={saving} onClick={() => void changeEmployeeStatus(row)}>
              {row.employmentStatus === "ACTIVE" ? "Ngừng hoạt động" : "Kích hoạt"}
            </Button>
          </Space>
        )
      }
    ],
    [departmentById, saving]
  );

  const pagination: TablePaginationConfig = {
    current: data.page + 1,
    pageSize: data.size,
    total: data.totalItems,
    onChange: (nextPage) => setPage(nextPage - 1)
  };

  const detailDepartment = detailEmployee ? departmentById.get(detailEmployee.departmentId) : undefined;
  const isLoadError = error === "Không tải được danh sách nhân viên";

  const contractColumns: ColumnsType<EmployeeContract> = [
    { title: "Loại hợp đồng", dataIndex: "contractType" },
    { title: "Ngày bắt đầu", dataIndex: "startDate" },
    { title: "Ngày kết thúc", dataIndex: "endDate" },
    { title: "Lương", dataIndex: "salary", render: (value: number) => value?.toLocaleString("vi-VN") }
  ];

  const skillColumns: ColumnsType<EmployeeSkill> = [
    { title: "Kỹ năng", dataIndex: "skillName" },
    { title: "Trình độ", dataIndex: "proficiencyLevel" }
  ];

  const emergencyContactColumns: ColumnsType<EmergencyContact> = [
    { title: "Họ và tên", dataIndex: "fullName" },
    { title: "Quan hệ", dataIndex: "relationship" },
    { title: "Số điện thoại", dataIndex: "phone" }
  ];

  return (
    <>
      <div className="page-header">
        <h1>Nhân viên</h1>
        <p>Tìm kiếm, cập nhật hồ sơ và quản lý trạng thái làm việc của nhân viên.</p>
      </div>

      <PageToolbar>
        <Segmented
          value={status}
          options={[
            { label: "Tất cả", value: "ALL" },
            { label: "Đang làm việc", value: "ACTIVE" },
            { label: "Ngừng hoạt động", value: "INACTIVE" }
          ]}
          onChange={(value) => {
            setPage(0);
            setStatus(String(value));
          }}
        />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
          Thêm nhân viên
        </Button>
      </PageToolbar>

      {error ? (
        <Alert
          type="warning"
          showIcon
          message={error}
          description={isLoadError ? "Kiểm tra token, tenant và kết nối backend rồi tải lại trang." : undefined}
          style={{ marginBottom: 16 }}
        />
      ) : null}

      {isLoadError ? null : (
        <AppTable<Employee>
          rowKey="id"
          loading={loading}
          dataSource={data.items}
          columns={columns}
          pagination={pagination}
        />
      )}

      <Drawer
        title="Chi tiết nhân viên"
        width="min(720px, calc(100vw - 32px))"
        open={Boolean(detailEmployee)}
        onClose={() => setDetailEmployee(null)}
      >
        {detailEmployee ? (
          <Tabs
            defaultActiveKey="profile"
            items={[
              {
                key: "profile",
                label: "Hồ sơ",
                children: (
                  <Descriptions bordered column={1} size="middle">
                    <Descriptions.Item label="Mã nhân viên">{detailEmployee.employeeNo}</Descriptions.Item>
                    <Descriptions.Item label="Họ và tên">{detailEmployee.fullName}</Descriptions.Item>
                    <Descriptions.Item label="Phòng ban">
                      {detailDepartment ? `${detailDepartment.code} - ${detailDepartment.name}` : detailEmployee.departmentId}
                    </Descriptions.Item>
                    <Descriptions.Item label="Ngày vào làm">{detailEmployee.hireDate}</Descriptions.Item>
                    <Descriptions.Item label="Trạng thái"><StatusTag value={detailEmployee.employmentStatus} /></Descriptions.Item>
                    <Descriptions.Item label="Email">{detailEmployee.email ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label="Số điện thoại">{detailEmployee.phone ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label="Vị trí">{detailEmployee.positionTitle ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label="Ngày sinh">{detailEmployee.dateOfBirth ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label="Giới tính">
                      {detailEmployee.gender === "MALE" ? "Nam" : detailEmployee.gender === "FEMALE" ? "Nữ" : detailEmployee.gender === "OTHER" ? "Khác" : "-"}
                    </Descriptions.Item>
                    <Descriptions.Item label="CMND/CCCD">{detailEmployee.nationalId ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label="Địa chỉ">{detailEmployee.address ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label="Số tài khoản">{detailEmployee.bankAccount ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label="Mã số thuế">{detailEmployee.taxCode ?? "-"}</Descriptions.Item>
                  </Descriptions>
                )
              },
              {
                key: "contracts",
                label: "Hợp đồng",
                children: (
                  <AppTable<EmployeeContract>
                    rowKey="id"
                    loading={detailLoading}
                    dataSource={detailContracts}
                    columns={contractColumns}
                    pagination={false}
                  />
                )
              },
              {
                key: "skills",
                label: "Kỹ năng",
                children: (
                  <AppTable<EmployeeSkill>
                    rowKey="id"
                    loading={detailLoading}
                    dataSource={detailSkills}
                    columns={skillColumns}
                    pagination={false}
                  />
                )
              },
              {
                key: "emergency",
                label: "Liên hệ khẩn cấp",
                children: (
                  <AppTable<EmergencyContact>
                    rowKey="id"
                    loading={detailLoading}
                    dataSource={detailEmergencyContacts}
                    columns={emergencyContactColumns}
                    pagination={false}
                  />
                )
              }
            ]}
          />
        ) : null}
      </Drawer>

      <FormDrawer open={openCreate} title={editingEmployee ? "Cập nhật nhân viên" : "Thêm nhân viên"} onClose={closeDrawer}>
        <Form form={form} layout="vertical" onFinish={submitEmployee}>
          <Form.Item label="Mã nhân viên" name="employeeNo" htmlFor="employee-code" rules={[{ required: !editingEmployee, message: "Nhập mã nhân viên" }]}>
            <Input id="employee-code" disabled={Boolean(editingEmployee)} />
          </Form.Item>
          <Form.Item label="Họ và tên" name="fullName" htmlFor="employee-name" rules={[{ required: true, message: "Nhập họ và tên" }]}>
            <Input id="employee-name" />
          </Form.Item>
          <Form.Item label="Phòng ban" name="departmentId" htmlFor="employee-department" rules={[{ required: true, message: "Chọn phòng ban" }]}>
            <Select
              id="employee-department"
              placeholder="Chọn phòng ban"
              options={departments.map((department) => ({
                value: department.id,
                label: `${department.code} - ${department.name}`
              }))}
            />
          </Form.Item>
          <Form.Item label="Ngày vào làm" name="hireDate" htmlFor="employee-hire-date" rules={[{ required: true, message: "Chọn ngày vào làm" }]}>
            <Input id="employee-hire-date" type="date" />
          </Form.Item>
          <Form.Item label="Email" name="email" htmlFor="employee-email">
            <Input id="employee-email" type="email" />
          </Form.Item>
          <Form.Item label="Số điện thoại" name="phone" htmlFor="employee-phone">
            <Input id="employee-phone" />
          </Form.Item>
          <Form.Item label="Ngày sinh" name="dateOfBirth" htmlFor="employee-dob">
            <Input id="employee-dob" type="date" />
          </Form.Item>
          <Form.Item label="Giới tính" name="gender" htmlFor="employee-gender">
            <Select
              id="employee-gender"
              placeholder="Chọn giới tính"
              options={[
                { value: "MALE", label: "Nam" },
                { value: "FEMALE", label: "Nữ" },
                { value: "OTHER", label: "Khác" }
              ]}
            />
          </Form.Item>
          <Form.Item label="CMND/CCCD" name="nationalId" htmlFor="employee-national-id">
            <Input id="employee-national-id" />
          </Form.Item>
          <Form.Item label="Địa chỉ" name="address" htmlFor="employee-address">
            <Input id="employee-address" />
          </Form.Item>
          <Form.Item label="Số tài khoản" name="bankAccount" htmlFor="employee-bank">
            <Input id="employee-bank" />
          </Form.Item>
          <Form.Item label="Mã số thuế" name="taxCode" htmlFor="employee-tax">
            <Input id="employee-tax" />
          </Form.Item>
          <Form.Item label="Vị trí" name="positionId" htmlFor="employee-position">
            <Select
              id="employee-position"
              placeholder="Chọn vị trí"
              options={positions.map((p) => ({ value: p.id, label: p.title }))}
            />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} disabled={!departments.length}>
            {editingEmployee ? "Lưu thay đổi" : "Lưu nhân viên"}
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
