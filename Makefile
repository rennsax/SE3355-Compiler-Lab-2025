.PHONY: docker-build docker-pull docker-run docker-run-backend transform build gradelab1 gradelab2 gradelab3 gradelab4 gradelab5 gradelab6 gradeall clean register format


IMAGE_NAME      := ipadsse3355/tigerlabs_env
IMAGE_VERSION   := 2025
IMAGE_NAME_FULL := $(IMAGE_NAME):$(IMAGE_VERSION)

docker-build:
	docker build . --tag $(IMAGE_NAME_FULL)

check-image:
	@if ! docker images | grep $(IMAGE_NAME) | grep -q $(IMAGE_VERSION); then \
		make docker-build; \
	else \
		echo "Image $(IMAGE_NAME_FULL) exists."; \
	fi


docker-run: check-image
	docker run -it --privileged --platform linux/amd64 -v $(shell pwd):/tiger-compiler $(IMAGE_NAME_FULL)

docker-run-backend: check-image
	docker run -dt --privileged --platform linux/amd64 -v $(shell pwd):/tiger-compiler $(IMAGE_NAME_FULL)

transform:
	find src scripts testdata -type f | xargs -I % sh -c 'dos2unix -n % /tmp/tmp; mv -f /tmp/tmp % || true;'

build:
	mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make

build-debug:
	mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && make

gradelab1:
	@bash scripts/grade.sh lab1

gradelab2:
	@bash scripts/grade.sh lab2

gradelab3:
	@bash scripts/grade.sh lab3

gradelab4:
	@bash scripts/grade.sh lab4

gradelab5-1:
	@bash scripts/grade.sh lab5-part1

gradelab5:
	@bash scripts/grade.sh lab5

clean:
	@rm -rf build/

register:
	python3 scripts/register.py

format:
	find . \( -name "*.h" -o -iname "*.cc" \) | xargs clang-format -i -style=file
