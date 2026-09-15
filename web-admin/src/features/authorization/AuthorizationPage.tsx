import { ReloadOutlined, SaveOutlined } from "@ant-design/icons";
import { Alert, Button, Checkbox, Col, Descriptions, Divider, Empty, Form, Input, Modal, Pagination, Popconfirm, Row, Select, Space, Spin, Switch, Table, Tabs, Tag, Typography, message } from "antd";
import { useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";

import { apiClient } from "../../shared/api/client";
import { API } from "../../shared/api/endpoints";
import { useApiMutation, useApiQuery } from "../../shared/api/query";
import type { PageResponse } from "../../shared/api/types";

const { Text } = Typography;

type AccessSnapshot = {
  userId: string | null;
  username: string;
  displayName: string;
  employeeId: string | null;
  roles: string[];
  authorities: string[];
};

type Permission = {
  code: string;
  module: string;
  action: string;
  description: string;
};

type Role = {
  id: string;
  code: string;
  name: string;
  description?: string;
  systemRole: boolean;
  permissionCodes: string[];
};

type User = {
  id: string;
  username: string;
  displayName: string;
  employeeId: string | null;
  enabled: boolean;
  roleIds: string[];
};

const MAIN_INVALIDATE_KEYS: readonly unknown[][] = [
  ["authz", "me"],
  ["authz", "permissions"],
  ["authz", "roles"],
  ["authz", "users"],
  ["departments"]
];

export default function AuthorizationPage() {
  const { t } = useTranslation();
  const [selectedRoleId, setSelectedRoleId] = useState<string>();
  const [rolePermissionDraft, setRolePermissionDraft] = useState<string[]>([]);
  const [selectedUserId, setSelectedUserId] = useState<string>();
  const [userRoleDraft, setUserRoleDraft] = useState<string[]>([]);

  const [createRoleOpen, setCreateRoleOpen] = useState(false);
  const [newRoleCode, setNewRoleCode] = useState("");
  const [newRoleName, setNewRoleName] = useState("");
  const [newRoleDesc, setNewRoleDesc] = useState("");
  const [newRoleTemplate, setNewRoleTemplate] = useState<string | undefined>();

  const [createUserOpen, setCreateUserOpen] = useState(false);
  const [newUsername, setNewUsername] = useState("");
  const [newDisplayName, setNewDisplayName] = useState("");
  const [newUserRoleIds, setNewUserRoleIds] = useState<string[]>([]);

  const [scopeUser, setScopeUser] = useState<string | undefined>();
  const [scopeDeptIds, setScopeDeptIds] = useState<string[]>([]);
  const [scopeModalOpen, setScopeModalOpen] = useState(false);
  const [auditPage, setAuditPage] = useState(0);
  const [auditSize, setAuditSize] = useState(10);
  const [newIdpGroup, setNewIdpGroup] = useState("");
  const [newIdpRoleId, setNewIdpRoleId] = useState<string | undefined>();

  const meQuery = useApiQuery<AccessSnapshot>(["authz", "me"], API.AUTH.ME);
  const permissionsQuery = useApiQuery<Permission[]>(["authz", "permissions"], API.AUTHZ.PERMISSIONS);
  const rolesQuery = useApiQuery<Role[]>(["authz", "roles"], API.AUTHZ.ROLES);
  const usersQuery = useApiQuery<User[]>(["authz", "users"], API.AUTHZ.USERS);
  const departmentsQuery = useApiQuery<PageResponse<{ id: string; name: string }>>(["departments"], API.DEPARTMENTS);
  const auditQuery = useApiQuery<any>(
    ["authz", "audit", auditPage, auditSize],
    `${API.AUTHZ.AUDIT}?page=${auditPage}&size=${auditSize}`
  );
  const idpQuery = useApiQuery<any[]>(["authz", "idp-mappings"], API.AUTHZ.IDP_MAPPINGS);

  const access = (meQuery.data as AccessSnapshot | undefined) ?? null;
  const permissions = (permissionsQuery.data as Permission[] | undefined) ?? [];
  const roles = (rolesQuery.data as Role[] | undefined) ?? [];
  const users = (usersQuery.data as User[] | undefined) ?? [];
  const departments = (departmentsQuery.data as PageResponse<{ id: string; name: string }> | undefined)?.items ?? [];

  const auditBody = auditQuery.data as any;
  const auditData: any[] = auditBody?.content ?? (Array.isArray(auditBody) ? auditBody : []);
  const auditTotal: number = auditBody?.content ? (auditBody.totalElements ?? 0) : (Array.isArray(auditBody) ? auditBody.length : 0);

  const idpMappings = ((idpQuery.data as { id: string; idpGroup: string; roleId: string; roleCode: string }[] | undefined) ?? []);

  const loading =
    meQuery.isLoading ||
    permissionsQuery.isLoading ||
    rolesQuery.isLoading ||
    usersQuery.isLoading ||
    departmentsQuery.isLoading;
  const error =
    meQuery.isError ||
    permissionsQuery.isError ||
    rolesQuery.isError ||
    usersQuery.isError ||
    departmentsQuery.isError
      ? t("pages.authorization.loadError")
      : null;

  const mainMutation = useApiMutation({ invalidateKeys: MAIN_INVALIDATE_KEYS });
  const toggleMutation = useApiMutation({ invalidateKeys: MAIN_INVALIDATE_KEYS });
  const scopeMutation = useApiMutation();
  const idpMutation = useApiMutation({ invalidateKeys: [["authz", "idp-mappings"]] });
  const saving = mainMutation.isPending || scopeMutation.isPending;

  // Preserve the old loadData default-selection semantics: whenever the current
  // selection is missing (initial load, or the selected entry was deleted),
  // fall back to the first entry.
  useEffect(() => {
    const list = rolesQuery.data as Role[] | undefined;
    if (list && (selectedRoleId === undefined || !list.some((r) => r.id === selectedRoleId))) {
      const next = list[0];
      setSelectedRoleId(next?.id);
      setRolePermissionDraft(next?.permissionCodes ?? []);
    }
  }, [rolesQuery.data, selectedRoleId]);

  useEffect(() => {
    const list = usersQuery.data as User[] | undefined;
    if (list && (selectedUserId === undefined || !list.some((u) => u.id === selectedUserId))) {
      const next = list[0];
      setSelectedUserId(next?.id);
      setUserRoleDraft(next?.roleIds ?? []);
    }
  }, [usersQuery.data, selectedUserId]);

  const selectedRole = roles.find((role) => role.id === selectedRoleId);
  const selectedUser = users.find((user) => user.id === selectedUserId);
  const roleNameById = useMemo(() => new Map(roles.map((role) => [role.id, `${role.code} - ${role.name}`])), [roles]);

  const permissionOptions = useMemo(
    () => permissions.map((permission) => ({
      label: `${permission.code} - ${permission.description}`,
      value: permission.code
    })),
    [permissions]
  );

  const roleOptions = useMemo(
    () => roles.map((role) => ({ label: `${role.code} - ${role.name}`, value: role.id })),
    [roles]
  );

  const reload = () => {
    void meQuery.refetch();
    void permissionsQuery.refetch();
    void rolesQuery.refetch();
    void usersQuery.refetch();
    void departmentsQuery.refetch();
  };

  const onSelectRole = (role: Role) => {
    setSelectedRoleId(role.id);
    setRolePermissionDraft(role.permissionCodes);
  };

  const onSelectUser = (user: User) => {
    setSelectedUserId(user.id);
    setUserRoleDraft(user.roleIds);
  };

  const saveRolePermissions = async () => {
    if (!selectedRole) {
      return;
    }
    try {
      await mainMutation.mutateAsync({
        url: `${API.AUTHZ.ROLES}/${selectedRole.id}/permissions`,
        method: "put",
        body: { permissionCodes: rolePermissionDraft }
      });
      message.success(t("pages.authorization.saved"));
    } catch {
      message.error(t("pages.authorization.saveError"));
    }
  };

  const saveUserRoles = async () => {
    if (!selectedUser) {
      return;
    }
    try {
      await mainMutation.mutateAsync({
        url: `${API.AUTHZ.USERS}/${selectedUser.id}/roles`,
        method: "put",
        body: { roleIds: userRoleDraft }
      });
      message.success(t("pages.authorization.saved"));
    } catch {
      message.error(t("pages.authorization.saveError"));
    }
  };

  const createRole = async () => {
    if (!newRoleCode.trim() || !newRoleName.trim()) {
      message.warning(t("common.createError"));
      return;
    }
    try {
      await mainMutation.mutateAsync({
        url: API.AUTHZ.ROLES,
        body: {
          code: newRoleCode.trim(),
          name: newRoleName.trim(),
          description: newRoleDesc.trim() || undefined,
          templateRoleId: newRoleTemplate
        }
      });
      message.success(t("pages.authorization.saved"));
      setCreateRoleOpen(false);
      setNewRoleCode("");
      setNewRoleName("");
      setNewRoleDesc("");
      setNewRoleTemplate(undefined);
    } catch {
      message.error(t("pages.authorization.saveError"));
    }
  };

  const deleteRole = async () => {
    if (!selectedRole) {
      return;
    }
    try {
      await mainMutation.mutateAsync({
        url: `${API.AUTHZ.ROLES}/${selectedRole.id}`,
        method: "delete"
      });
      message.success(t("pages.authorization.saved"));
    } catch {
      message.error(t("pages.authorization.saveError"));
    }
  };

  const toggleUser = async (userId: string, enabled: boolean) => {
    try {
      await toggleMutation.mutateAsync({
        url: `${API.AUTHZ.USERS}/${userId}/enabled`,
        method: "put",
        body: { enabled }
      });
      message.success(t("pages.authorization.saved"));
    } catch {
      message.error(t("pages.authorization.saveError"));
    }
  };

  const createUser = async () => {
    if (!newUsername.trim() || !newDisplayName.trim()) {
      message.warning(t("common.createError"));
      return;
    }
    try {
      await mainMutation.mutateAsync({
        url: API.AUTHZ.USERS,
        body: {
          username: newUsername.trim(),
          displayName: newDisplayName.trim(),
          roleIds: newUserRoleIds
        }
      });
      message.success(t("pages.authorization.saved"));
      setCreateUserOpen(false);
      setNewUsername("");
      setNewDisplayName("");
      setNewUserRoleIds([]);
    } catch {
      message.error(t("pages.authorization.saveError"));
    }
  };

  const openScopeModal = async () => {
    if (!scopeUser) return;
    try {
      const res = await apiClient.get<string[]>(`${API.AUTHZ.USERS}/${scopeUser}/scopes`);
      setScopeDeptIds(res.data);
    } catch {
      setScopeDeptIds([]);
    }
    setScopeModalOpen(true);
  };

  const saveScopes = async () => {
    if (!scopeUser) return;
    try {
      await scopeMutation.mutateAsync({
        url: `${API.AUTHZ.USERS}/${scopeUser}/scopes`,
        method: "put",
        body: { departmentIds: scopeDeptIds }
      });
      message.success(t("pages.authorization.saved"));
      setScopeModalOpen(false);
    } catch {
      message.error(t("pages.authorization.saveError"));
    }
  };

  const createIdpMapping = async () => {
    if (!newIdpGroup.trim() || !newIdpRoleId) return;
    try {
      await idpMutation.mutateAsync({
        url: API.AUTHZ.IDP_MAPPINGS,
        body: { idpGroup: newIdpGroup.trim(), roleId: newIdpRoleId }
      });
      setNewIdpGroup("");
      setNewIdpRoleId(undefined);
    } catch { message.error(t("pages.authorization.saveError")); }
  };

  const deleteIdpMapping = async (id: string) => {
    try {
      await idpMutation.mutateAsync({
        url: `${API.AUTHZ.IDP_MAPPINGS}/${id}`,
        method: "delete"
      });
    } catch { message.error(t("pages.authorization.saveError")); }
  };
  const roleTable = (
    <Row gutter={[16, 16]}>
      <Col xs={24} lg={10}>
        <Space direction="vertical" size="small" style={{ width: "100%" }}>
          <Button type="primary" onClick={() => setCreateRoleOpen(true)}>
            {t("pages.authorization.newRole")}
          </Button>
          <Table<Role>
            rowKey="id"
            size="middle"
            pagination={false}
            dataSource={roles}
            rowSelection={{ type: "radio", selectedRowKeys: selectedRoleId ? [selectedRoleId] : [], onSelect: onSelectRole }}
            columns={[
              { title: t("pages.authorization.role"), dataIndex: "code" },
              { title: t("common.name"), dataIndex: "name" },
              {
                title: t("pages.authorization.permissions"),
                render: (_, role) => role.permissionCodes.length
              }
            ]}
          />
        </Space>
      </Col>
      <Col xs={24} lg={14}>
        {selectedRole ? (
          <Space direction="vertical" size="middle" style={{ width: "100%" }}>
            <Descriptions bordered size="small" column={1}>
              <Descriptions.Item label={t("pages.authorization.role")}>
                <Space>
                  <span>{selectedRole.code}</span>
                  {selectedRole.systemRole && <Tag color="blue">{t("pages.authorization.systemRole")}</Tag>}
                </Space>
              </Descriptions.Item>
              <Descriptions.Item label={t("common.description")}>{selectedRole.description ?? "-"}</Descriptions.Item>
            </Descriptions>
            <Checkbox.Group
              style={{ display: "grid", gap: 8 }}
              value={rolePermissionDraft}
              options={permissionOptions}
              onChange={(values) => setRolePermissionDraft(values.map(String))}
            />
            <Space>
              <Button type="primary" icon={<SaveOutlined />} loading={saving} onClick={saveRolePermissions}>
                {t("pages.authorization.savePermissions")}
              </Button>
              {!selectedRole.systemRole && (
                <Popconfirm
                  title={t("pages.authorization.deleteRoleConfirm")}
                  onConfirm={deleteRole}
                  okText={t("common.delete")}
                  cancelText={t("common.cancel")}
                >
                  <Button danger loading={saving}>
                    {t("pages.authorization.deleteRole")}
                  </Button>
                </Popconfirm>
              )}
            </Space>
          </Space>
        ) : (
          <Empty description={t("pages.authorization.noRole")} />
        )}
      </Col>
    </Row>
  );

  const userTable = (
    <Row gutter={[16, 16]}>
      <Col xs={24} lg={12}>
        <Space direction="vertical" size="small" style={{ width: "100%" }}>
          <Button type="primary" onClick={() => setCreateUserOpen(true)}>
            {t("pages.authorization.newUser")}
          </Button>
          <Table<User>
            rowKey="id"
            size="middle"
            pagination={false}
            dataSource={users}
            rowSelection={{ type: "radio", selectedRowKeys: selectedUserId ? [selectedUserId] : [], onSelect: onSelectUser }}
            columns={[
              { title: t("pages.authorization.username"), dataIndex: "username" },
              { title: t("common.name"), dataIndex: "displayName" },
              {
                title: t("pages.authorization.roles"),
                render: (_, user) => user.roleIds.length
              },
              {
                title: t("common.status"),
                render: (_, user) => <Tag color={user.enabled ? "green" : "default"}>{user.enabled ? t("status.ACTIVE") : t("status.INACTIVE")}</Tag>
              }
            ]}
          />
        </Space>
      </Col>
      <Col xs={24} lg={12}>
        {selectedUser ? (
          <Space direction="vertical" size="middle" style={{ width: "100%" }}>
            <Descriptions bordered size="small" column={1}>
              <Descriptions.Item label={t("pages.authorization.username")}>
                <Space>
                  <span>{selectedUser.username}</span>
                  <Switch
                    checked={selectedUser.enabled}
                    checkedChildren={t("status.ACTIVE")}
                    unCheckedChildren={t("status.INACTIVE")}
                    onChange={(checked) => toggleUser(selectedUser.id, checked)}
                  />
                </Space>
              </Descriptions.Item>
              <Descriptions.Item label={t("common.employee")}>{selectedUser.displayName ?? "-"}</Descriptions.Item>
            </Descriptions>
            <Checkbox.Group
              style={{ display: "grid", gap: 8 }}
              value={userRoleDraft}
              options={roleOptions}
              onChange={(values) => setUserRoleDraft(values.map(String))}
            />
            <Button type="primary" icon={<SaveOutlined />} loading={saving} onClick={saveUserRoles}>
              {t("pages.authorization.saveRoles")}
            </Button>
          </Space>
        ) : (
          <Empty description={t("pages.authorization.noUser")} />
        )}
      </Col>
    </Row>
  );

  return (
    <>
      <div className="page-header">
        <div>
          <h1>{t("pages.authorization.title")}</h1>
          <p>{t("pages.authorization.subtitle")}</p>
        </div>
        <Button icon={<ReloadOutlined />} onClick={reload}>
          {t("pages.authorization.reload")}
        </Button>
      </div>

      {error && <Alert type="error" showIcon message={error} style={{ marginBottom: 16 }} />}
      <Spin spinning={loading}>
        <Tabs
          items={[
            {
              key: "me",
              label: t("pages.authorization.myAccess"),
              children: access ? (
                <Space direction="vertical" size="middle" style={{ width: "100%" }}>
                  <Descriptions bordered size="small" column={1}>
                    <Descriptions.Item label={t("pages.authorization.username")}>{access.username}</Descriptions.Item>
                    <Descriptions.Item label={t("common.name")}>{access.displayName}</Descriptions.Item>
                    <Descriptions.Item label={t("common.employee")}>{access.displayName ?? "-"}</Descriptions.Item>
                  </Descriptions>
                  <div>
                    <Text strong>{t("pages.authorization.roles")}</Text>
                    <div style={{ marginTop: 8 }}>{access.roles.map((role) => <Tag key={role}>{role}</Tag>)}</div>
                  </div>
                  <div>
                    <Text strong>{t("pages.authorization.authorities")}</Text>
                    <div style={{ marginTop: 8 }}>{access.authorities.map((authority) => <Tag key={authority}>{authority}</Tag>)}</div>
                  </div>
                </Space>
              ) : (
                <Empty />
              )
            },
            { key: "roles", label: t("pages.authorization.roles"), children: roleTable },
            { key: "users", label: t("pages.authorization.users"), children: userTable },
            {
              key: "scopes",
              label: t("pages.authorization.scopes"),
              children: (
                <Space direction="vertical" size="middle" style={{ width: "100%" }}>
                  <Row gutter={12} align="middle">
                    <Col>
                      <Select
                        style={{ width: 240 }}
                        placeholder={t("pages.authorization.username")}
                        value={scopeUser}
                        onChange={(value) => setScopeUser(value)}
                        options={users.map((u) => ({ label: u.username, value: u.id }))}
                      />
                    </Col>
                    <Col>
                      <Button type="primary" disabled={!scopeUser} onClick={openScopeModal}>
                        {t("pages.authorization.manageScopes")}
                      </Button>
                    </Col>
                  </Row>
                  <Modal
                    title={t("pages.authorization.departmentScopes")}
                    open={scopeModalOpen}
                    onOk={saveScopes}
                    onCancel={() => setScopeModalOpen(false)}
                    confirmLoading={saving}
                    destroyOnHidden
                  >
                    <Checkbox.Group
                      style={{ display: "grid", gap: 8 }}
                      value={scopeDeptIds}
                      options={departments.map((d) => ({ label: d.name, value: d.id }))}
                      onChange={(values) => setScopeDeptIds(values.map(String))}
                    />
                  </Modal>
                </Space>
              )
            },
            {
              key: "audit",
              label: t("pages.authorization.audit"),
              children: (
                <Space direction="vertical" size="middle" style={{ width: "100%" }}>
                  <Table<any>
                    rowKey={(_, i) => String(i)}
                    size="middle"
                    pagination={false}
                    dataSource={auditData}
                    columns={[
                      { title: t("common.date"), dataIndex: "createdAt", render: (v) => v ? new Date(v).toLocaleString() : "-" },
                      { title: t("pages.authorization.auditActor"), dataIndex: "actor" },
                      { title: t("pages.authorization.auditAction"), dataIndex: "action" },
                      { title: t("pages.authorization.auditTarget"), dataIndex: "targetType", render: (v) => v ?? "-" },
                      { title: t("pages.authorization.auditDetail"), dataIndex: "detail" }
                    ]}
                  />
                  <Pagination
                    current={auditPage + 1}
                    pageSize={auditSize}
                    total={auditTotal}
                    showSizeChanger
                    pageSizeOptions={["5", "10", "20", "50"]}
                    onChange={(page, size) => { setAuditPage(page - 1); setAuditSize(size); }}
                    showTotal={(total) => `${t("common.name")}: ${total}`}
                  />
                </Space>
              )
            },
            {
              key: "idpMappings",
              label: t("pages.authorization.idpMappings"),
              children: (
                <Space direction="vertical" size="middle" style={{ width: "100%" }}>
                  <Row gutter={12} align="middle">
                    <Col>
                      <Input
                        style={{ width: 200 }}
                        placeholder={t("pages.authorization.idpGroup")}
                        value={newIdpGroup}
                        onChange={(e) => setNewIdpGroup(e.target.value)}
                      />
                    </Col>
                    <Col>
                      <Select
                        style={{ width: 200 }}
                        placeholder={t("pages.authorization.roles")}
                        value={newIdpRoleId}
                        onChange={(value) => setNewIdpRoleId(value)}
                        options={roles.map((r) => ({ label: `${r.code} - ${r.name}`, value: r.id }))}
                      />
                    </Col>
                    <Col>
                      <Button type="primary" onClick={createIdpMapping}>
                        {t("pages.authorization.addMapping")}
                      </Button>
                    </Col>
                  </Row>
                  <Table<{ id: string; idpGroup: string; roleId: string; roleCode: string }>
                    rowKey="id"
                    size="middle"
                    pagination={false}
                    dataSource={idpMappings}
                    columns={[
                      { title: t("pages.authorization.idpGroup"), dataIndex: "idpGroup" },
                      { title: t("pages.authorization.role"), render: (_, record) => record.roleCode ?? roleNameById.get(record.roleId) ?? "-" },
                      {
                        title: t("common.actions"),
                        render: (_, record) => (
                          <Popconfirm
                            title={t("pages.authorization.deleteMappingConfirm")}
                            onConfirm={() => deleteIdpMapping(record.id)}
                            okText={t("common.delete")}
                            cancelText={t("common.cancel")}
                          >
                            <Button danger size="small">{t("pages.authorization.deleteMapping")}</Button>
                          </Popconfirm>
                        )
                      }
                    ]}
                  />
                </Space>
              )
            }
          ]}
        />
      </Spin>

      <Modal
        title={t("pages.authorization.createRole")}
        open={createRoleOpen}
        onCancel={() => { setCreateRoleOpen(false); setNewRoleCode(""); setNewRoleName(""); setNewRoleDesc(""); setNewRoleTemplate(undefined); }}
        footer={null}
        destroyOnHidden
      >
        <Form layout="vertical" onFinish={createRole}>
          <Form.Item label={t("pages.authorization.code")} required>
            <Input value={newRoleCode} onChange={(e) => setNewRoleCode(e.target.value)} placeholder={t("pages.authorization.code")} />
          </Form.Item>
          <Form.Item label={t("common.name")} required>
            <Input value={newRoleName} onChange={(e) => setNewRoleName(e.target.value)} placeholder={t("common.name")} />
          </Form.Item>
          <Form.Item label={t("common.description")}>
            <Input value={newRoleDesc} onChange={(e) => setNewRoleDesc(e.target.value)} placeholder={t("common.description")} />
          </Form.Item>
          <Form.Item label={t("pages.authorization.templateRole")}>
            <Select
              allowClear
              placeholder={t("pages.authorization.noTemplate")}
              value={newRoleTemplate}
              onChange={(value) => setNewRoleTemplate(value)}
              options={roles.map((r) => ({ label: `${r.code} - ${r.name}`, value: r.id }))}
            />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} block>
            {t("pages.authorization.createRole")}
          </Button>
        </Form>
      </Modal>

      <Modal
        title={t("pages.authorization.createUser")}
        open={createUserOpen}
        onCancel={() => { setCreateUserOpen(false); setNewUsername(""); setNewDisplayName(""); setNewUserRoleIds([]); }}
        footer={null}
        destroyOnHidden
      >
        <Form layout="vertical" onFinish={createUser}>
          <Form.Item label={t("pages.authorization.username")} required>
            <Input value={newUsername} onChange={(e) => setNewUsername(e.target.value)} placeholder={t("pages.authorization.username")} />
          </Form.Item>
          <Form.Item label={t("common.name")} required>
            <Input value={newDisplayName} onChange={(e) => setNewDisplayName(e.target.value)} placeholder={t("common.name")} />
          </Form.Item>
          <Form.Item label={t("pages.authorization.roles")}>
            <Select
              mode="multiple"
              placeholder={t("pages.authorization.roles")}
              value={newUserRoleIds}
              onChange={(values) => setNewUserRoleIds(values)}
              options={roles.map((r) => ({ label: `${r.code} - ${r.name}`, value: r.id }))}
            />
          </Form.Item>
          <Button type="primary" htmlType="submit" loading={saving} block>
            {t("pages.authorization.createUser")}
          </Button>
        </Form>
      </Modal>
    </>
  );
}
