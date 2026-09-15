import { PlusOutlined } from "@ant-design/icons";
import { Alert, Button, Descriptions, Drawer, Form, Input, message, Popconfirm, Segmented, Select, Space, Tabs } from "antd";
import type { ColumnsType } from "antd/es/table";
import type { TablePaginationConfig } from "antd/es/table";
import { useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { API } from "../../shared/api/endpoints";
import { asArray, useApiMutation, useApiQuery } from "../../shared/api/query";
import { hasAuthority } from "../../shared/auth/jwt";
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
  managerId?: string;
  managerName?: string;
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
  size: 20,
  totalItems: 0,
  totalPages: 0
};

export default function EmployeesPage() {
  const { t, i18n } = useTranslation();
  const [status, setStatus] = useState<string>("ALL");
  const [page, setPage] = useState(0);
  const [pageSize, setPageSize] = useState(20);
  const [openCreate, setOpenCreate] = useState(false);
  const [detailEmployee, setDetailEmployee] = useState<Employee | null>(null);
  const [editingEmployee, setEditingEmployee] = useState<Employee | null>(null);
  const [managerEmployeeId, setManagerEmployeeId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
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

  const employeesQuery = useApiQuery<PageResponse<Employee>>(
    ['employees', page, pageSize, status],
    API.EMPLOYEES,
    { config: { params: { page, size: pageSize, status: status === "ALL" ? undefined : status } } }
  );
  const data: PageResponse<Employee> = { ...emptyPage, ...employeesQuery.data, items: employeesQuery.data?.items ?? [] };

  const departmentsQuery = useApiQuery<PageResponse<Department>>(
    ['departments', 'lookup'],
    API.DEPARTMENTS,
    { config: { params: { page: 0, size: 100 } } }
  );
  const departments = departmentsQuery.data?.items ?? [];

  const positionsQuery = useApiQuery<PageResponse<Position>>(
    ['positions', 'lookup'],
    API.POSITIONS,
    { config: { params: { page: 0, size: 500 } } }
  );
  const positions = positionsQuery.data?.items ?? [];

  const detailId = detailEmployee?.id;
  const contractsQuery = useApiQuery<PageResponse<EmployeeContract>>(
    ['employees', detailId, 'contracts'],
    `${API.EMPLOYEES}/${detailId}/contracts`,
    { enabled: Boolean(detailId), config: { params: { page: 0, size: 50 } } }
  );
  const skillsQuery = useApiQuery<PageResponse<EmployeeSkill>>(
    ['employees', detailId, 'skills'],
    `${API.EMPLOYEES}/${detailId}/skills`,
    { enabled: Boolean(detailId), config: { params: { page: 0, size: 50 } } }
  );
  const contactsQuery = useApiQuery<PageResponse<EmergencyContact>>(
    ['employees', detailId, 'emergency-contacts'],
    `${API.EMPLOYEES}/${detailId}/emergency-contacts`,
    { enabled: Boolean(detailId), config: { params: { page: 0, size: 50 } } }
  );
  const detailContracts = detailId ? asArray<EmployeeContract>(contractsQuery.data?.items) : [];
  const detailSkills = detailId ? asArray<EmployeeSkill>(skillsQuery.data?.items) : [];
  const detailEmergencyContacts = detailId ? asArray<EmergencyContact>(contactsQuery.data?.items) : [];
  const detailLoading = Boolean(detailId) && (contractsQuery.isLoading || skillsQuery.isLoading || contactsQuery.isLoading);

  const saveMutation = useApiMutation({ invalidateKeys: [['employees']] });
  const statusMutation = useApiMutation({ invalidateKeys: [['employees']] });
  const deleteMutation = useApiMutation({ invalidateKeys: [['employees']] });
  const managerMutation = useApiMutation();
  const loading = employeesQuery.isLoading;
  const saving = saveMutation.isPending || statusMutation.isPending;
  const deleting = deleteMutation.isPending;
  const managerSaving = managerMutation.isPending;

  useEffect(() => {
    if (detailEmployee) {
      setManagerEmployeeId(detailEmployee.managerId ?? null);
    }
  }, [detailEmployee]);

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
        await saveMutation.mutateAsync({
          url: `${API.EMPLOYEES}/${editingEmployee.id}/profile`,
          method: "put",
          body: profilePayload,
        });
      } else {
        await saveMutation.mutateAsync({
          url: API.EMPLOYEES,
          body: {
            employeeNo: values.employeeNo?.trim(),
            fullName: profilePayload.fullName,
            departmentId: profilePayload.departmentId,
            hireDate: profilePayload.hireDate
          },
        });
      }
      form.resetFields();
      setOpenCreate(false);
      setEditingEmployee(null);
    } catch {
      setError(
        editingEmployee
          ? t("pages.employees.updateError")
          : t("pages.employees.createError")
      );
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
    setError(null);
    try {
      await statusMutation.mutateAsync({
        url: `${API.EMPLOYEES}/${employee.id}/status`,
        method: "patch",
        body: { employmentStatus: nextStatus },
      });
    } catch {
      setError(t("pages.employees.statusError"));
    }
  };

  const deleteEmployee = async (id: string) => {
    setError(null);
    try {
      await deleteMutation.mutateAsync({ url: `${API.EMPLOYEES}/${id}`, method: "delete" });
      message.success(t("pages.employees.deleteSuccess"));
    } catch {
      setError(t("pages.employees.deleteError"));
    }
  };

  const assignManager = async (employeeId: string, managerId: string | null) => {
    if (!managerId) return;
    try {
      await managerMutation.mutateAsync({
        url: `${API.EMPLOYEES}/${employeeId}/manager`,
        method: "put",
        body: { managerId },
      });
      message.success(t("pages.employees.managerAssigned"));
      // Update local detail state
      if (detailEmployee?.id === employeeId) {
        const mgr = data.items.find((e) => e.id === managerId);
        setDetailEmployee({
          ...detailEmployee,
          managerId,
          managerName: mgr?.fullName ?? managerId
        });
      }
      setManagerEmployeeId(null);
    } catch {
      message.error(t("pages.employees.managerAssignError"));
    }
  };

  const columns = useMemo<ColumnsType<Employee>>(
    () => [
      { title: t("pages.employees.employeeNo"), dataIndex: "employeeNo", width: 160 },
      { title: t("pages.employees.fullName"), dataIndex: "fullName" },
      { title: t("common.email"), dataIndex: "email", width: 200, ellipsis: true },
      { title: t("pages.employees.phone"), dataIndex: "phone", width: 130 },
      { title: t("common.position"), dataIndex: "positionTitle", width: 160 },
      {
        title: t("common.department"),
        dataIndex: "departmentId",
        width: 220,
        render: (value: string) => {
          const department = departmentById.get(value);
          return department ? `${department.code} - ${department.name}` : value;
        }
      },
      { title: t("pages.employees.hireDate"), dataIndex: "hireDate", width: 140 },
      {
        title: t("common.status"),
        dataIndex: "employmentStatus",
        width: 160,
        render: (value: string) => <StatusTag value={value} />
      },
      {
        title: t("pages.employees.manager"),
        dataIndex: "managerName",
        width: 200,
        ellipsis: true,
        render: (value: string) => value ?? "-"
      },
      {
        title: t("common.actions"),
        key: "actions",
        width: 380,
        render: (_, row) => (
          <Space>
            <Button size="small" onClick={() => openEdit(row)}>
              {t("common.edit")}
            </Button>
            <Button size="small" onClick={() => setDetailEmployee(row)}>
              {t("common.detail")}
            </Button>
            <Button size="small" disabled={saving} onClick={() => void changeEmployeeStatus(row)}>
              {row.employmentStatus === "ACTIVE" ? t("common.deactivate") : t("common.activate")}
            </Button>
            {hasAuthority("employee:delete") && (
              <Popconfirm
                title={t("pages.employees.deleteTitle")}
                description={t("pages.employees.deleteDescription", { name: row.fullName })}
                okText={t("common.delete")}
                cancelText={t("common.cancel")}
                okButtonProps={{ danger: true, loading: deleting }}
                onConfirm={() => void deleteEmployee(row.id)}
              >
                <Button size="small" danger disabled={deleting}>
                  {t("common.delete")}
                </Button>
              </Popconfirm>
            )}
          </Space>
        )
      }
    ],
    [departmentById, saving, deleting, t]
  );

  const pagination: TablePaginationConfig = {
    current: data.page + 1,
    pageSize,
    total: data.totalItems,
    onChange: (nextPage, nextPageSize) => {
      if (nextPageSize !== pageSize) {
        setPage(0);
        setPageSize(nextPageSize);
        return;
      }
      setPage(nextPage - 1);
    }
  };

  const detailDepartment = detailEmployee ? departmentById.get(detailEmployee.departmentId) : undefined;
  const fetchFailed = employeesQuery.isError && !employeesQuery.data;
  const visibleError = error ?? (fetchFailed ? t("pages.employees.loadError") : null);
  const isLoadError = visibleError === t("pages.employees.loadError");

  const contractColumns: ColumnsType<EmployeeContract> = [
    { title: t("pages.employees.contractType"), dataIndex: "contractType" },
    { title: t("pages.employees.startDate"), dataIndex: "startDate" },
    { title: t("pages.employees.endDate"), dataIndex: "endDate" },
    { title: t("pages.employees.salary"), dataIndex: "salary", render: (value: number) => value?.toLocaleString(i18n.language === "en" ? "en-US" : "vi-VN") }
  ];

  const skillColumns: ColumnsType<EmployeeSkill> = [
    { title: t("pages.employees.skill"), dataIndex: "skillName" },
    { title: t("pages.employees.proficiency"), dataIndex: "proficiencyLevel" }
  ];

  const emergencyContactColumns: ColumnsType<EmergencyContact> = [
    { title: t("pages.employees.fullName"), dataIndex: "fullName" },
    { title: t("pages.employees.relationship"), dataIndex: "relationship" },
    { title: t("pages.employees.phone"), dataIndex: "phone" }
  ];

  return (
    <>
      <div className="page-header">
        <h1>{t("pages.employees.title")}</h1>
        <p>{t("pages.employees.subtitle")}</p>
      </div>

      <PageToolbar>
        <Segmented
          value={status}
          options={[
            { label: t("common.all"), value: "ALL" },
            { label: t("status.ACTIVE"), value: "ACTIVE" },
            { label: t("status.INACTIVE"), value: "INACTIVE" }
          ]}
          onChange={(value) => {
            setPage(0);
            setStatus(String(value));
          }}
        />
        <Button type="primary" icon={<PlusOutlined />} onClick={() => setOpenCreate(true)}>
          {t("pages.employees.add")}
        </Button>
      </PageToolbar>

      {visibleError ? (
        <Alert
          type="warning"
          showIcon
          message={visibleError}
          description={isLoadError ? t("pages.employees.loadErrorDescription") : undefined}
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
          scroll={{ y: "calc(100vh - 340px)" }}
        />
      )}

      <Drawer
        title={t("pages.employees.detailTitle")}
        width="min(720px, calc(100vw - 32px))"
        open={Boolean(detailEmployee)}
        onClose={() => {
          setDetailEmployee(null);
          setManagerEmployeeId(null);
        }}
      >
        {detailEmployee ? (
          <Tabs
            defaultActiveKey="profile"
            items={[
              {
                key: "profile",
                label: t("pages.employees.profile"),
                children: (
                  <Descriptions bordered column={1} size="middle">
                    <Descriptions.Item label={t("pages.employees.employeeNo")}>{detailEmployee.employeeNo}</Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.fullName")}>{detailEmployee.fullName}</Descriptions.Item>
                    <Descriptions.Item label={t("common.department")}>
                      {detailDepartment ? `${detailDepartment.code} - ${detailDepartment.name}` : detailEmployee.departmentId}
                    </Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.hireDate")}>{detailEmployee.hireDate}</Descriptions.Item>
                    <Descriptions.Item label={t("common.status")}><StatusTag value={detailEmployee.employmentStatus} /></Descriptions.Item>
                    <Descriptions.Item label={t("common.email")}>{detailEmployee.email ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.phone")}>{detailEmployee.phone ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label={t("common.position")}>{detailEmployee.positionTitle ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.manager")}>
                      <Space>
                        <span>{detailEmployee.managerName ?? "-"}</span>
                        <Select
                          style={{ width: 280 }}
                          placeholder={t("pages.employees.selectManager")}
                          showSearch
                          allowClear
                          filterOption={(input, option) =>
                            ((option?.label as string) ?? "").toLowerCase().includes(input.toLowerCase())
                          }
                          options={data.items
                            .filter((e) => e.id !== detailEmployee.id)
                            .map((e) => ({ value: e.id, label: `${e.fullName} (${e.employeeNo})` }))}
                          value={managerEmployeeId}
                          onChange={(value) => {
                            setManagerEmployeeId(value);
                            if (value) {
                              void assignManager(detailEmployee.id, value);
                            }
                          }}
                          loading={managerSaving}
                        />
                      </Space>
                    </Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.dateOfBirth")}>{detailEmployee.dateOfBirth ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.gender")}>
                      {detailEmployee.gender ? t(`gender.${detailEmployee.gender}`, detailEmployee.gender) : "-"}
                    </Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.nationalId")}>{detailEmployee.nationalId ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.address")}>{detailEmployee.address ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.bankAccount")}>{detailEmployee.bankAccount ?? "-"}</Descriptions.Item>
                    <Descriptions.Item label={t("pages.employees.taxCode")}>{detailEmployee.taxCode ?? "-"}</Descriptions.Item>
                  </Descriptions>
                )
              },
              {
                key: "contracts",
                label: t("pages.employees.contracts"),
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
                label: t("pages.employees.skills"),
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
                label: t("pages.employees.emergencyContacts"),
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

      <FormDrawer open={openCreate} title={editingEmployee ? t("pages.employees.update") : t("pages.employees.add")} onClose={closeDrawer}>
        <Form form={form} layout="vertical" onFinish={submitEmployee}>
          <Form.Item label={t("pages.employees.employeeNo")} name="employeeNo" htmlFor="employee-code" rules={[{ required: !editingEmployee, message: t("pages.employees.enterEmployeeNo") }]}>
            <Input id="employee-code" disabled={Boolean(editingEmployee)} />
          </Form.Item>
          <Form.Item label={t("pages.employees.fullName")} name="fullName" htmlFor="employee-name" rules={[{ required: true, message: t("pages.employees.enterFullName") }]}>
            <Input id="employee-name" />
          </Form.Item>
          <Form.Item label={t("common.department")} name="departmentId" htmlFor="employee-department" rules={[{ required: true, message: t("pages.employees.chooseDepartment") }]}>
            <Select
              id="employee-department"
              placeholder={t("pages.employees.selectDepartment")}
              options={departments.map((department) => ({
                value: department.id,
                label: `${department.code} - ${department.name}`
              }))}
            />
          </Form.Item>
          <Form.Item label={t("pages.employees.hireDate")} name="hireDate" htmlFor="employee-hire-date" rules={[{ required: true, message: t("pages.employees.chooseHireDate") }]}>
            <Input id="employee-hire-date" type="date" />
          </Form.Item>
          <Form.Item label={t("common.email")} name="email" htmlFor="employee-email">
            <Input id="employee-email" type="email" />
          </Form.Item>
          <Form.Item label={t("pages.employees.phone")} name="phone" htmlFor="employee-phone">
            <Input id="employee-phone" />
          </Form.Item>
          <Form.Item label={t("pages.employees.dateOfBirth")} name="dateOfBirth" htmlFor="employee-dob">
            <Input id="employee-dob" type="date" />
          </Form.Item>
          <Form.Item label={t("pages.employees.gender")} name="gender" htmlFor="employee-gender">
            <Select
              id="employee-gender"
              placeholder={t("pages.employees.selectGender")}
              options={[
                { value: "MALE", label: t("gender.MALE") },
                { value: "FEMALE", label: t("gender.FEMALE") },
                { value: "OTHER", label: t("gender.OTHER") }
              ]}
            />
          </Form.Item>
          <Form.Item label={t("pages.employees.nationalId")} name="nationalId" htmlFor="employee-national-id">
            <Input id="employee-national-id" />
          </Form.Item>
          <Form.Item label={t("pages.employees.address")} name="address" htmlFor="employee-address">
            <Input id="employee-address" />
          </Form.Item>
          <Form.Item label={t("pages.employees.bankAccount")} name="bankAccount" htmlFor="employee-bank">
            <Input id="employee-bank" />
          </Form.Item>
          <Form.Item label={t("pages.employees.taxCode")} name="taxCode" htmlFor="employee-tax">
            <Input id="employee-tax" />
          </Form.Item>
          <Form.Item label={t("common.position")} name="positionId" htmlFor="employee-position">
            <Select
              id="employee-position"
              placeholder={t("pages.employees.selectPosition")}
              options={positions.map((p) => ({ value: p.id, label: p.title }))}
            />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} disabled={!departments.length}>
            {editingEmployee ? t("pages.employees.saveChanges") : t("pages.employees.saveEmployee")}
          </Button>
        </Form>
      </FormDrawer>
    </>
  );
}
