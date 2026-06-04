import { Alert, Button } from "antd";
import { isRouteErrorResponse, useNavigate, useRouteError } from "react-router-dom";

export default function ErrorPage() {
  const error = useRouteError();
  const navigate = useNavigate();
  const message = isRouteErrorResponse(error)
    ? `${error.status} ${error.statusText}`
    : error instanceof Error
      ? error.message
      : "Lỗi ứng dụng không xác định.";

  return (
    <div className="error-page">
      <Alert
        type="error"
        showIcon
        message="Lỗi ứng dụng"
        description={message}
        action={
          <Button size="small" onClick={() => navigate("/dashboard")}>
            Về tổng quan
          </Button>
        }
      />
    </div>
  );
}
