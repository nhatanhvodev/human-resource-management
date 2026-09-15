package com.company.hrms.asset.interfaces.api;

import com.company.hrms.asset.application.AssetService;
import com.company.hrms.asset.domain.Asset;
import com.company.hrms.shared.interfaces.api.PageResponse;
import com.company.hrms.shared.security.SecurityUtils;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/assets")
public class AssetController {
    private final AssetService service;

    public AssetController(AssetService service) { this.service = service; }

    @PostMapping
    @PreAuthorize("hasAuthority('asset:create')")
    public AssetResponse create(@RequestBody CreateAssetRequest request) {
        return toResponse(service.create(request.name(), request.category(), request.serialNumber(),
            request.purchaseDate(), request.purchasePrice()));
    }

    @GetMapping
    @PreAuthorize("hasAuthority('asset:read')")
    public PageResponse<AssetResponse> list(@RequestParam(required = false) String status, Pageable pageable) {
        if (status != null && !status.isEmpty()) {
            return PageResponse.from(service.listByStatus(status, pageable).map(AssetController::toResponse));
        }
        return PageResponse.from(service.list(pageable).map(AssetController::toResponse));
    }

    @GetMapping("/mine")
    @PreAuthorize("hasAuthority('self:access')")
    public List<AssetResponse> mine(
            @RequestHeader(value = "X-Employee-Id", required = false) UUID headerEmployeeId) {
        UUID employeeId = SecurityUtils.resolveSelfEmployeeId(headerEmployeeId);
        return service.listByEmployee(employeeId).stream().map(AssetController::toResponse).toList();
    }

    @PostMapping("/{id}/assign")
    @PreAuthorize("hasAuthority('asset:update')")
    public AssetResponse assign(@PathVariable UUID id, @RequestBody AssignRequest request) {
        return toResponse(service.assign(id, request.employeeId()));
    }

    @PostMapping("/{id}/unassign")
    @PreAuthorize("hasAuthority('asset:update')")
    public AssetResponse unassign(@PathVariable UUID id) {
        return toResponse(service.unassign(id));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('asset:delete')")
    public void delete(@PathVariable UUID id) { service.delete(id); }

    private static AssetResponse toResponse(Asset a) {
        return new AssetResponse(a.getId(), a.getName(), a.getCategory(), a.getSerialNumber(),
            a.getStatus().name(), a.getAssignedTo(), a.getAssignedDate(), a.getPurchaseDate(), a.getPurchasePrice());
    }

    public record CreateAssetRequest(String name, String category, String serialNumber,
                                      LocalDate purchaseDate, Double purchasePrice) {}
    public record AssetResponse(UUID id, String name, String category, String serialNumber,
                                 String status, UUID assignedTo, LocalDate assignedDate,
                                 LocalDate purchaseDate, Double purchasePrice) {}
    public record AssignRequest(UUID employeeId) {}
}
