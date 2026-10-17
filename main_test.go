package main

import "testing"

func TestName(t *testing.T) {
	if got := name(); got != "whatsapp-leads" {
		t.Fatalf("name() = %q, want %q", got, "whatsapp-leads")
	}
}
