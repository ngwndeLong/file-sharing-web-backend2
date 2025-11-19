package handlers

import (
	"net/http"

	"github.com/dath-251-thuanle/file-sharing-web-backend2/internal/service"
	"github.com/gin-gonic/gin"
)

type TotpHandler struct {
	TotpService service.TotpService
}

func NewTotpHandler(totpService service.TotpService) *TotpHandler {
	return &TotpHandler{
		TotpService: totpService,
	}
}

func (h *TotpHandler) SetupTOTP(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "userID not found"})
		return
	}

	resp, err := h.TotpService.SetupTOTP(userID.(int))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":   "TOTP secret generated",
		"totpSetup": resp,
	})
}

type VerifyTOTPRequest struct {
	Code string `json:"code" binding:"required"`
}

func (h *TotpHandler) VerifyTOTP(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "userID not found"})
		return
	}

	var req VerifyTOTPRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	ok, err := h.TotpService.VerifyTOTP(userID.(int), req.Code)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid TOTP code"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":     "TOTP verified successfully",
		"totpEnabled": true,
	})
}