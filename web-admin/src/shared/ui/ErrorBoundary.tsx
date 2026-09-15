import { Alert, Button } from "antd";
import { Component, type ReactNode } from "react";

type Props = { children: ReactNode };
type State = { error: Error | null };

export class ErrorBoundary extends Component<Props, State> {
  state: State = { error: null };

  static getDerivedStateFromError(error: Error): State {
    return { error };
  }

  componentDidCatch(error: Error): void {
    // P0: surface render crashes instead of blank screen; hook to log service here.
    console.error("UI crash caught by ErrorBoundary:", error);
  }

  private handleReset = (): void => {
    this.setState({ error: null });
    window.location.href = "/dashboard";
  };

  render(): ReactNode {
    if (this.state.error) {
      return (
        <div style={{ maxWidth: 640, margin: "48px auto", padding: "0 16px" }}>
          <Alert
            type="error"
            showIcon
            message="Đã xảy ra lỗi"
            description={this.state.error.message || "Vui lòng thử lại."}
            action={
              <Button size="small" onClick={this.handleReset}>
                Về Dashboard
              </Button>
            }
          />
        </div>
      );
    }
    return this.props.children;
  }
}
