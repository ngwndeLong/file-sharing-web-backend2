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

	c.JSON(http.StatusOK, resp)
}
