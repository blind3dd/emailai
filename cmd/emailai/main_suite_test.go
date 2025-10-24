package main

import (
	"testing"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

func TestEmailAI(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "EmailAI WorkerPool Suite")
}
