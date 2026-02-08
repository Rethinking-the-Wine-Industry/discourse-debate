export default {
  setupComponent(args, component) {
    const stance = args.post?.stance;
    if (stance) {
      component.classNames.push("discourse-debates");
      component.classNames.push(`stance-${stance}`);
    }
  },
};
